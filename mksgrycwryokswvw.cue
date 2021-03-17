package terraform

envs: [string]: {
	zone: _
	configurations: ["tczfxjfecbzgxqeq-cjppmetyaderslgo-infra"]: {
		source: *(#TerraformLib & {
			tag: "tczfxjfecbzgxqeq-cjppmetyaderslgo-infra-v7.3.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/tczfxjfecbzgxqeq-cjppmetyaderslgo-infra"
		providers: cjppmetyaderslgo: ipkmllvrrijnkfib:           _
		providers: cjppmetyaderslgo: "\(zone.name)": _
		tfvars: {
			zone_name:     zone.name
			zone_provider: zone.provider.type
			domain_name:   zone.domain_name
			if zone.name == "infra-zwtkxvyalrulrfjt" {
				tczfxjfecbzgxqeq_realm_name: "Comnet"
			}
		}
	}
}
