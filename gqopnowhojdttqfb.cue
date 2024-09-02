package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["aws_ingress"]: {
		source: *(#TerraformLib & {
			tag: "aws_ingress-v1.0.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/aws_ingress"
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		tfvars: {
			zone_name:       zone.name
			domain_name:     zone.domain_name
			infra_zone_name: infra_zone.name

			aws_region: zone.provider.region

			cjppmetyaderslgo_aws_role: configurations.cjppmetyaderslgo_aws_sts_roles.tfvars.roles.operator.cjppmetyaderslgo_role_name

			dtmyfegilaxrvzuc_cjppmetyaderslgo_aws_role: "power_user_\(infra_zone_name)"
			dtmyfegilaxrvzuc_region_name:               envs[infra_zone_name].configurations.dtmyfegilaxrvzuc.tfvars.dtmyfegilaxrvzuc_region_name
			dtmyfegilaxrvzuc_table_name:                envs[infra_zone_name].configurations.dtmyfegilaxrvzuc.tfvars.dtmyfegilaxrvzuc_table_name

			vpc_name:     configurations.seotfaqctmulanqa.tfvars.vpc_name
			cluster_name: configurations.zsanvdsnathnlyaf.tfvars.cluster_name
			ingresses: private: {}
		}
	}
}
