package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["qdjiggzhpimmwyzi"]: {
		source: *(#TerraformLib & {
			tag: "qdjiggzhpimmwyzi-v1.3.4"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/qdjiggzhpimmwyzi"
		providers: cjppmetyaderslgo: "\(zone.name)":       _
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		tfvars: {
			zone_name:                               zone.name
			infra_zone_name:                         infra_zone.name
			data_bucket_name:                        "\(infra_zone.name)-iam-provisioning-\(infra_zone.providers.aws.account_id)-data"
			terraform_locks_dynamodb_table_name:     "\(infra_zone.name)-iam-provisioning-\(infra_zone.providers.aws.account_id)-tf-locks"
			terraform_states_bucket_name:            "\(infra_zone.name)-iam-provisioning-\(infra_zone.providers.aws.account_id)-tf-states"
			cjppmetyaderslgo_aws_sts_read_only_role: "read_only_\(infra_zone.name)"
		}
	}
}
