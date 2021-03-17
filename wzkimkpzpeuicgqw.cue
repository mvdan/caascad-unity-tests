package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["qxxixpswrmhalwdt"]: {
		source: *(#TerraformLib & {
			tag: "qxxixpswrmhalwdt-v2.0.1"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/qxxixpswrmhalwdt"
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		force_generation: 1
		tfvars: {
			zone_name:           zone.name
			domain_name:         zone.domain_name
			private_domain_name: zone.priv_domain_name
			infra_zone_name:     infra_zone.name

			aws_region: zone.provider.region

			cjppmetyaderslgo_aws_role: envs[zone.name].configurations.cjppmetyaderslgo_aws_sts_roles.tfvars.roles.operator.cjppmetyaderslgo_role_name

			key_pair: envs[zone.name].configurations.smymjpkigjwiaxnu.tfvars.keypair_name

			vpc_id:   string
			vpc_name: string
			if (zone.provider.vpc_id == _|_) {
				vpc_id:   ""
				vpc_name: envs[zone.name].configurations.seotfaqctmulanqa.tfvars.vpc_name
			}
			if (zone.provider.vpc_id != _|_) {
				vpc_id:   zone.provider.vpc_id
				vpc_name: ""
			}

			route53_secret_backend_name: *"aws" | string
			if infra_zone.name == "infra-zwtkxvyalrulrfjt" {
				route53_secret_backend_name: "aws-prod"
			}

			bastion_tags: fqdn: "bst.\(zone.name).comnet.com"

			remote_ip_prefix_ssh: [ "127.0.0.1/24"]
		}
	}
}
