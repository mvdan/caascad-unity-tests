package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["todlrceqzsfstqnz"]: {
		source: *(#TerraformLib & {
			tag: "todlrceqzsfstqnz-v2.1.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/todlrceqzsfstqnz"
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		tfvars: {
			zone_name:                              zone.name
			infra_domain_name:                      zone.domain_name
			mail_domain_name:                       *zone.domain_name | string
			infra_zone_name:                        infra_zone.name
			aws_region:                             "eu-west-1"
			sns_forward_subscription_email_address: "support.comnet@comnet.com"
			cjppmetyaderslgo_aws_sts_role:                     "power_user_\(infra_zone.name)"
		}
	}
}

envs: ["infra-zwtkxvyalrulrfjt"]: configurations: todlrceqzsfstqnz: tfvars: {
	mail_domain_name: "comnetpriv.com"
}
