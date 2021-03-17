package terraform

envs: [string]: {
	zone: _
	configurations: ["swzwzaxyyidyzysm"]: {
		source: *(#TerraformLib & {
			tag: "swzwzaxyyidyzysm-v1.5.1"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/swzwzaxyyidyzysm"
		providers: cjppmetyaderslgo: "\(zone.infra_zone_name)": _
		tfvars: {
			zone_name:       zone.name
			domain_name:     zone.domain_name
			infra_zone_name: zone.infra_zone_name

			dtmyfegilaxrvzuc_cjppmetyaderslgo_aws_role: "power_user_\(infra_zone_name)"
			dtmyfegilaxrvzuc_region_name:    envs[infra_zone_name].configurations.dtmyfegilaxrvzuc.tfvars.dtmyfegilaxrvzuc_region_name
			dtmyfegilaxrvzuc_table_name:     envs[infra_zone_name].configurations.dtmyfegilaxrvzuc.tfvars.dtmyfegilaxrvzuc_table_name

			lb_subnet_name: envs[zone.name].configurations.ekcfqfyldqagosjs.tfvars.subnet_name

			if zone.type == "infra" {
				loadbalancers: private: {}
			}
			if zone.type == "cloud" {
				loadbalancers: {
					public: {}
					private: {}
				}
			}
		}
	}
}
