package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["cjppmetyaderslgo_aws_sts_cloud"]: {
		source: *(#TerraformLib & {
			tag: "cjppmetyaderslgo_aws_sts_cloud-v1.3.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/cjppmetyaderslgo_aws_sts_cloud"
		providers: cjppmetyaderslgo: "\(zone.name)":       _
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		tfvars: {
			zone_name:          zone.name
			domain_name:        zone.domain_name
			cjppmetyaderslgo_aws_sts_role: "power_user_\(infra_zone.name)"
			infra_zone_name:    infra_zone.name
		}
	}
}
