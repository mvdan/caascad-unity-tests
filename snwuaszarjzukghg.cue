package terraform

envs: [string]: {
	zone: _
	configurations: ["cjppmetyaderslgo_aws_sts_infra"]: {
		source: *(#TerraformLib & {
			tag: "cjppmetyaderslgo_aws_sts_infra-v1.2.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/cjppmetyaderslgo_aws_sts_infra"
		providers: cjppmetyaderslgo: "\(zone.name)":   _
		providers: cjppmetyaderslgo: ipkmllvrrijnkfib: _
		tfvars: {
			zone_name:                     zone.name
			domain_name:                   zone.domain_name
			cjppmetyaderslgo_aws_sts_role: "power_user_\(zone.providers.aws.account_name)"
		}
	}
}
