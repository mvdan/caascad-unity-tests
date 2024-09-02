package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["dtmyfegilaxrvzuc"]: {
		source: *(#TerraformLib & {
			tag: "dtmyfegilaxrvzuc-v1.0.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/dtmyfegilaxrvzuc"
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		tfvars: {
			zone_name:                     zone.name
			domain_name:                   zone.domain_name
			infra_zone_name:               infra_zone.name
			cjppmetyaderslgo_aws_sts_role: "power_user_\(infra_zone.name)"

			dtmyfegilaxrvzuc_table_name:  "dtmyfegilaxrvzuc_\(infra_zone_name)"
			dtmyfegilaxrvzuc_region_name: "eu-west-3"

			dynamodb_billing_mode: "PAY_PER_REQUEST" | "PROVISIONED"
			dynamodb_billing_mode: "PAY_PER_REQUEST"
		}
	}
}
