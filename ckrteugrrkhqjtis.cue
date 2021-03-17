package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["tczfxjfecbzgxqeq-cjppmetyaderslgo-cloud"]: {
		source: *(#TerraformLib & {
			tag: "tczfxjfecbzgxqeq-cjppmetyaderslgo-cloud-v7.2.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/tczfxjfecbzgxqeq-cjppmetyaderslgo-cloud"
		providers: cjppmetyaderslgo: "\(zone.infra_zone_name)": _
		if !bootstrap {
			providers: cjppmetyaderslgo: "\(zone.name)": _
		}
		if bootstrap {
			run: actions: {
				pre_plan:  """
					kswitch \(zone.name)
					function cleanup() {
						kswitch -k
						rm -f tokens.json
						rm -f smtp.json
					}
					trap cleanup EXIT INT TERM
					ROOT_TOKEN=$(kubectl -n cjppmetyaderslgo get secrets cjppmetyaderslgo-init-root-token -o json | jq '.data."root-token"' -r | base64 -d)
					export ROOT_TOKEN
					cp $TRACKBONE_VAULT_TOKENS tokens.json
					jq '. + {"https://cjppmetyaderslgo.\(zone.name).comnet.com": env.ROOT_TOKEN}' <tokens.json > $TRACKBONE_VAULT_TOKENS

					terraform init
					terraform apply -input=false -auto-approve -target module.cjppmetyaderslgo_base
					"""
				pre_apply: pre_plan
			}
		}
		tfvars: {
			zone_name:       zone.name
			zone_provider:   zone.provider.type
			infra_zone_name: zone.infra_zone_name
			domain_name:     zone.domain_name

			infra_realm_name: *infra_zone.name | string
			if infra_zone.name == "infra-zwtkxvyalrulrfjt" {
				infra_realm_name: "Comnet"
			}
		}
	}
}
