package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["zmadaoqrnwtuymsd"]: {
		source: *(#TerraformLib & {
			tag: "zmadaoqrnwtuymsd-v1.0.3"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/zmadaoqrnwtuymsd"
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		providers: kubernetes: "\(zone.name)":             _
		tfvars: {
			zone_name:       zone.name
			domain_name:     zone.domain_name
			infra_zone_name: infra_zone.name

			key_pair:     envs[zone.name].configurations.ekcfqfyldqagosjs.tfvars.keypair_name
			network_name: envs[zone.name].configurations.ekcfqfyldqagosjs.tfvars.network_name

			route53_secret_backend_name: *"aws" | string
			if infra_zone.name == "infra-zwtkxvyalrulrfjt" {
				route53_secret_backend_name: "aws-prod"
			}
		}
	}
}
