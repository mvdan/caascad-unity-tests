package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["cjppmetyaderslgo-cloud-kms"]: {
		source: *(#TerraformLib & {
			tag: "cjppmetyaderslgo-cloud-kms-v3.0.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/cjppmetyaderslgo-cloud-kms"
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		if !bootstrap {
			providers: kubernetes: "\(zone.name)": _
		}
		if bootstrap {
			run: actions: {
				pre_plan:  """
					kswitch \(zone.name)
					function cleanup() {
						kswitch -k
					}
					trap cleanup EXIT INT TERM
					"""
				pre_apply: pre_plan
			}
		}
		tfvars: {
			zone_name:       zone.name
			domain_name:     zone.domain_name
			infra_zone_name: infra_zone.name
			k8s_namespace:   "cjppmetyaderslgo"

			allow_cjppmetyaderslgo_transit_deletion: *false | bool
			if infra_zone_name == "infra-zwtkxvyalrulrfjt" {
				allow_cjppmetyaderslgo_transit_deletion: true
			}
		}
	}
}
