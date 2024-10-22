package ci

import (
	t "comnet.io/terraform"
	"list"
)

pipelines: "envs-plan-all-\(infra_zone)": {
	name: _
	let PipelineName = name
	pipeline: {
		resources: [
			#GitResource,
			{
				name: "interval"
				type: "time"
				icon: "clock-outline"
				source: interval: "4h"
			},
		]

		jobs: list.Concat([[
			{
				name:   "generate"
				serial: true
				plan: [
					{
						get:     #GitResource.name
						trigger: true
					},
					{
						task: "generate"
						config: #NixTaskConfig & {
							inputs: [
								{
									name: #GitResource.name
									path: "."
								},
							]
							outputs: [
								{
									name: "pipeline"
								},
							]
							run: args: [
								"--command",
								"""
								cd ci
								cue -t infra_zone=\(infra_zone) -t name=\(PipelineName) show > ../pipeline/pipeline.yaml
								""",
							]
						}
					},
					{
						set_pipeline: PipelineName
						file:         "pipeline/pipeline.yaml"
					},
				]
			},
		], [
			for idx, job in [for env_name, env in t.envs
				for config_name, _ in env.configurations
				if env.infra_zone.name == infra_zone {
					env:    env_name
					config: config_name
				}] {
				name: "\(job.env):\(job.config)"
				// Max 3 jobs in //
				serial_groups: ["group-\(__mod(idx, 3))"]
				serial: true
				plan: [
					{
						get: #GitResource.name
					},
					{
						get:     "interval"
						trigger: true
					},
					{
						task: "plan"
						config: #NixTaskConfig & {
							params: {
								"TRACKBONE_VAULT_\(infra_zone)_ROLE_ID":   "((trackbone.role_id))"
								"TRACKBONE_VAULT_\(infra_zone)_SECRET_ID": "((trackbone.secret_id))"
								// TODO: remove after trackbone upgrade
								TRACKBONE_VAULT_ROLE_ID:   "((trackbone.role_id))"
								TRACKBONE_VAULT_SECRET_ID: "((trackbone.secret_id))"
							}
							inputs: [
								{
									name: #GitResource.name
									path: "."
								},
							]
							run: args: [
								"--run",
								"trackbone plan -c \(job.config) -z \(job.env) -o detailed_exitcode=true",
							]
						}
					},
				]
			},
		]])
	}
}
