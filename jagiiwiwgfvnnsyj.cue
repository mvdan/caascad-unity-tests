package terraform

import (
	"encoding/yaml"
	"strings"
	"text/template"
	tb "comnet.io/trackbone"
)

#AnsibleConfig: {
	tb.#Config
	type: "ansible-playbook"
	ansible: {
		playbook_path: string
		args:          *["-i", "inventory.yaml", "-e", "@extra_vars.yaml"] | [...string]
		extra_vars: {...}
		inventory: {...}
	}
	files: "extra_vars.yaml": {
		content: yaml.Marshal(ansible.extra_vars)
	}
	files: "inventory.yaml": {
		content: yaml.Marshal(ansible.inventory)
	}
	env_vars: ANSIBLE_COLLECTIONS_PATHS: "./collections"
	run: {
		let Args = strings.Join(ansible.args, " ")
		options: _
		actions: plan:  template.Execute("""
			[[ -f "requirements.yml" ]] && ansible-galaxy collection install -r requirements.yml
			export ANSIBLE_CALLBACK_PLUGINS="plugins/callback"
			export ANSIBLE_CALLBACK_WHITELIST="stats_exporter"
			export ANSIBLE_STATS_EXPORTER_PATH="$(mktemp)"
			ansible-playbook --check "\(ansible.playbook_path)" \(Args)
			{{ if .detailed_exitcode }}
			if [[ "$(jq -r '.changed > 0' "$ANSIBLE_STATS_EXPORTER_PATH")" == "true" ]]; then exit 2; fi
			{{ end }}
			{{- if .output_dir }}
			jq -r '. | to_entries | map([.key, .value] | join(": ")) | join(", ")' "$ANSIBLE_STATS_EXPORTER_PATH" > {{ .output_dir }}/plan.md
			{{- end }}
			""", options)
		actions: apply: """
			[[ -f "requirements.yml" ]] && ansible-galaxy collection install -r requirements.yml
			ansible-playbook "\(ansible.playbook_path)" \(Args)
			"""
		actions: plan_destroy: """
			qvhuuynllrunnger "Not implemented."
			exit 1
			"""
		actions: destroy: """
			qvhuuynllrunnger "Not implemented."
			exit 1
			"""
	}
}

envs: [string]: {
	zone:        _
	infra_zone:  _
	parent_zone: _
	configurations: ["lvnhynxhvptukwuq"]: {
		providers: kubernetes: "\(zone.name)":  _
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		source: *(tb.#GitSource & {
			url:  "https://git.ipkmllvrrijnkfib.comnet.com/comnet/quay-robots.git"
			tag:  *"v1.1.0" | string
			path: "deploy-to-kube"
		}) | tb.#GitSource | #LocalSource
		ansible: {
			playbook_path: "setup.yml"
			extra_vars: {
				cjppmetyaderslgo_addr: "https://cjppmetyaderslgo.\(infra_zone.name).comnet.com"

				if zone.type == "infra" {
					namespace_list: [
						"concourse-infra",
						"monitoring",
						"tczfxjfecbzgxqeq",
					]
				}
				if zone.type == "cloud" {
					namespace_list: [
						"concourse",
						"concourse-infra",
						"monitoring",
						"tczfxjfecbzgxqeq",
					]
				}
				if zone.type == "client" {
					namespace_list: [
						if zone.name == "ipkmllvrrijnkfib" {"tczfxjfecbzgxqeq"},
					]
				}

				secrets: [
					for _, v in ["internal", "external"] if zone.type == "infra" || zone.type == "cloud" {
						"secret/concourse-infra/global/docker-registry-\(v)-ro:value"
					},
					if zone.type == "client" {
						"secret/concourse-infra/global/docker-registry-external-ro-\(parent_zone.name):value"
					},
					// Add dev secret only on staging environments
					if infra_zone.name == "infra-zwtkxvyalrulrfjt" {
						"secret/concourse-infra/global/docker-registry-dev-ro:value"
					},
				]
			}
		}
	}
}
