package ci

import (
	"tool/cli"
	"tool/exec"
	"encoding/yaml"

	t "comnet.io/terraform"
)

command: show: {
	$short: "Show yaml of a concourse pipeline (on the command line specify -t name=<pipeline-name>)"

	var: {
		name: string @tag(name)
	}

	task: print: cli.Print & {
		text: yaml.Marshal(pipelines[var.name].pipeline)
	}

}

command: apply: {
	$short: "Apply concourse pipelines"

	var: {
		team: *"infra" | string @tag(team)
	}

	task: switch: exec.Run & {
		cmd: [
			"fly",
			"switch",
			"-z", infra_zone,
			"-n", var.team,
		]
	}

	task: {
		for _, p in pipelines {
			"set-\(p.name)": exec.Run & {
				$after: task.switch
				cmd: [
					"fly",
					"set-pipeline",
					"--non-interactive",
					"-c", "/dev/stdin",
					"-p", p.name,
				]
				stdin: yaml.Marshal(p.pipeline)
			}
			"unpause-\(p.name)": exec.Run & {
				$after: task["set-\(p.name)"]
				cmd: [
					"fly",
					"unpause-pipeline",
					"-p", p.name,
				]
			}
		}
	}
}

command: "trigger-plan": {
	$short: "Trigger plan on zone/config"

	var: {
		zone:   *"" | string      @tag(zone)
		config: *"" | string      @tag(config)
		team:   *"infra" | string @tag(team)
	}

	task: switch: exec.Run & {
		cmd: [
			"fly",
			"switch",
			"-z", infra_zone,
			"-n", var.team,
		]
	}

	task: {
		for n, e in t.envs
		for c, _ in e.configurations
		if ((var.zone == "" || var.zone == n) && infra_zone == e.infra_zone.name && (var.config == "" || var.config == c)) {
			"trigger-plan-\(n)-\(c)": exec.Run & {
				$after: task.switch

				cmd: [
					"fly", "trigger-job", "-j",
					"envs-plan-all-\(infra_zone)/plan-\(n)-\(c)",
				]
			}
		}
	}
}
