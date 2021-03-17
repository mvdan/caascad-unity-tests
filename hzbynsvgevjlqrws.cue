package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["lvujjitqpazwkvop"]: {
		source: *(#TerraformLib & {
			tag: "lvujjitqpazwkvop-v1.4.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/lvujjitqpazwkvop"
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		force_generation: 2
		tfvars: {
			zone_name:       zone.name
			domain_name:     zone.domain_name
			infra_zone_name: infra_zone.name

			key_pair:     *envs[zone.name].configurations.ekcfqfyldqagosjs.tfvars.keypair_name | string
			network_name: *envs[zone.name].configurations.ekcfqfyldqagosjs.tfvars.network_name | string

			route53_secret_backend_name: *"aws" | string
			if infra_zone.name == "infra-zwtkxvyalrulrfjt" {
				route53_secret_backend_name: "aws-prod"
			}

			bastion_metadata: {
				tags: "bastion"
				fqdn: "bst.\(zone.name).\(domain_name)"
			}

			secgroup_name: *"comnet-\(zone.name)-bastion" | string
		}
	}
}

envs: ["infra-zwtkxvyalrulrfjt"]: configurations: lvujjitqpazwkvop: tfvars: {
	key_pair: "comnet-key"
}

envs: ["ps"]: configurations: lvujjitqpazwkvop: tfvars: {
	network_name: "411ba502-2ff3-4562-b67c-d87de0ed7091"
	network_id:   "c786e2f2-46e3-4352-bd5e-e5d8e8c294fa"
}

envs: ["oaftdnzzmubkjwdy"]: configurations: lvujjitqpazwkvop: tfvars: {
	key_pair: "provisioning-oaftdnzzmubkjwdy" // FIXME: not aligned with ekcfqfyldqagosjs
}

envs: ["slbcrinxgodkifok"]: configurations: lvujjitqpazwkvop: tfvars: {
	network_name: "d5452b98-0b03-4c77-ab25-d14d50b5933d"
}

envs: ["mjgymrtsrufltfdo"]: configurations: lvujjitqpazwkvop: tfvars: {
	network_name: "7fc33f38-5f4c-435a-a78e-e672f9067674"
	network_id:   "1165bc20-9cca-4f58-93d6-5123211e2786"
}
