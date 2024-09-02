package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["smymjpkigjwiaxnu"]: {
		source: *(#TerraformLib & {
			tag: "smymjpkigjwiaxnu-v4.0.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/smymjpkigjwiaxnu"
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		providers: cjppmetyaderslgo: ipkmllvrrijnkfib:     _
		tfvars: {
			zone_name:       zone.name
			domain_name:     zone.domain_name
			infra_zone_name: infra_zone.name

			aws_region: zone.provider.region

			route53_secret_backend_name: *"aws" | "aws-prod"
			if infra_zone.name == "infra-zwtkxvyalrulrfjt" {
				route53_secret_backend_name: "aws-prod"
			}

			// Used to create route53 AK/SK (all in prod account)
			cjppmetyaderslgo_aws_iam_role: "account_bootstrap_374014906619"

			keypair_name: "provisioning-\(zone.name)"

			cjppmetyaderslgo_aws_role: configurations.cjppmetyaderslgo_aws_sts_roles.tfvars.roles.operator.cjppmetyaderslgo_role_name
		}
	}
}
