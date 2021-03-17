package terraform

envs: [string]: {
	zone: _
	configurations: ["quvxqpfzejqzfbrk"]: {
		source: *(#TerraformLib & {
			tag: "quvxqpfzejqzfbrk-v1.3.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/quvxqpfzejqzfbrk"
		providers: cjppmetyaderslgo: "\(zone.name)": _
		tfvars: {
			domain_name:        zone.domain_name
			zone_name:          zone.name
			cjppmetyaderslgo_aws_sts_role: "power_user_\(zone.name)"
		}
	}
}
