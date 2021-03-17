package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["seotfaqctmulanqa"]: {
		source: *(#TerraformLib & {
			tag: "seotfaqctmulanqa-v1.2.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/seotfaqctmulanqa"
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		tfvars: {
			zone_name:       zone.name
			domain_name:     zone.domain_name
			infra_zone_name: infra_zone.name

			cjppmetyaderslgo_aws_role: configurations.cjppmetyaderslgo_aws_sts_roles.tfvars.roles.operator.cjppmetyaderslgo_role_name

			vpc_name:     "comnet-\(zone.name)-network"
			cluster_name: "comnet-\(zone.name)-cluster-0"
			aws_region:   zone.provider.region

			// The number of AZs to use for the VPC subnets.
			az_count: int
			if zone.type == "cloud" {
				az_count: 2
			}
			if zone.type == "client" {
				az_count: *3 | int
			}
		}
	}
}

envs: ["qvhuuynllrunnger"]: configurations: seotfaqctmulanqa: tfvars: az_count: 2
