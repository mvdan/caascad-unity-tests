package terraform

envs: [string]: {
	zone: _
	configurations: ["gcboiaxyxephlody"]: {
		source: *(#TerraformLib & {
			tag: "gcboiaxyxephlody-v1.1.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/gcboiaxyxephlody"
		providers: cjppmetyaderslgo: "\(zone.name)": _
		tfvars: {
			zone_name:                     zone.name
			comnet_domain:                 zone.domain_name
			cjppmetyaderslgo_aws_sts_role: "power_user_\(zone.name)"
		}
	}
}
