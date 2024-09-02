package ci

if infra_zone == "infra-zwtkxvyalrulrfjt" {

	pipelines: "envs-update-zones": pipeline: {

		resources: [
			#GitResource & {
				name: "comnet-zones"
				source: {
					uri: "((git-ipkmllvrrijnkfib.url))/comnet/comnet-zones.git"
				}
			},
			#GitResource,
		]

		jobs: [{
			name: "update-comnet-zones"
			plan: [
				{
					get:     "comnet-zones"
					trigger: true
				},
				{
					get: #GitResource.name
				},
				{
					task: "update-comnet-zones"
					config: #NixTaskConfig & {
						params: {
							GITLAB_URL:      "((git-ipkmllvrrijnkfib.url))"
							GITLAB_TOKEN:    "((git-ipkmllvrrijnkfib.token))"
							GIT_CREDENTIALS: "https://((git-ipkmllvrrijnkfib.username)):((git-ipkmllvrrijnkfib.token))@git.ipkmllvrrijnkfib.comnet.com"
						}
						inputs: [{
							name: #GitResource.name
							path: "."
						}]
						outputs: [{
							name: #GitResource.name
							path: "."
						}]
						run: path: "./ci/update-comnet-zones.sh"
					}
				},
			]
		}]

	}

}
