package terraform

envs: [string]: {
	zone: _
	configurations: ["tgdthifiuygwkuvd"]: {
		source: *(#TerraformLib & {
			tag: "tgdthifiuygwkuvd-v1.4.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/tgdthifiuygwkuvd"
		providers: cjppmetyaderslgo: "\(zone.name)": _
		tfvars: {
			zone_name:                     zone.name
			domain_name:                   zone.domain_name
			cjppmetyaderslgo_aws_sts_role: "power_user_\(zone.name)"
		}
	}
}
