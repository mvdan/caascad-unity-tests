package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["todlrceqzsfstqnz_rules"]: {
		source: *(#TerraformLib & {
			tag: "todlrceqzsfstqnz_rules-v2.1.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/todlrceqzsfstqnz_rules"
		providers: cjppmetyaderslgo: "ipkmllvrrijnkfib": _
		tfvars: {
			zone_name:                 zone.name
			ses_receipt_rule_set_name: "todlrceqzsfstqnz_rules-\(zone.name)"
			receipt_rule_recipient:    "support.\(zone.name)@comnet.com"
			cjppmetyaderslgo_aws_sts_role:        "power_user_comnet-prod"
		}
	}
}
