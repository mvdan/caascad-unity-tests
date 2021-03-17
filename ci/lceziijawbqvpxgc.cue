package ci

pipelines: "envs-alert-diff-\(infra_zone)": pipeline: {

	resource_types: [
		{
			name: "cron-resource"
			type: "docker-image"
			source: repository: "cftoolsmiths/cron-resource"
		},
	]

	resources: [
		{
			name: "every-morning"
			type: "cron-resource"
			source: {
				location:         "Europe/Paris"
				expression:       "0 9 * * 1-5"
				fire_immediately: true
			}
		},
		#GitResource,
	]

	jobs: [{
		name: "alert"
		plan: [
			{
				get: #GitResource.name
			},
			{
				get:     "every-morning"
				trigger: true
			},
			{
				task:   "alert"
				config: #NixTaskConfig & {
					inputs: [
						{
							name: #GitResource.name
							path: "."
						},
					]
					params: {
						USERNAME:            "((ci-admin.username))"
						PASSWORD:            "((ci-admin.password))"
						INFRA_ZONE:          infra_zone
						TEAM:                "infra"
						ROCKET_CHAT_WEBHOOK: "((rocketchat-webhook.ug_trackbone))"
					}
					run: args: [
						"--command",
						"""
						cd ci
						./alert-failed-plans.sh
						""",
					]
				}
			},
		]
	}]

}
