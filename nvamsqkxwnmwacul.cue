package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["tqiqsmvypugfqwsb"]: {
		source: *(#TerraformLib & {
			tag: "tqiqsmvypugfqwsb-v1.2.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/tqiqsmvypugfqwsb"
		providers: cjppmetyaderslgo: "ipkmllvrrijnkfib": _
		tfvars: {
			zone_name:             zone.name
			cjppmetyaderslgo_aws_sts_role:    "power_user_comnet-orga"
			aws_account_name:      zone.provider.account_name
			aws_organization_unit: zone.provider.ou
			aws_root_email:        "support.\(zone.name)@comnet.com"
		}
	}
}
