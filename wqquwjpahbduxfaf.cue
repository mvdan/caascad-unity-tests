package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["cjppmetyaderslgo_aws_sts_roles"]: {
		source: *(#TerraformLib & {
			tag: "cjppmetyaderslgo_aws_sts_roles-v1.1.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/cjppmetyaderslgo_aws_sts_roles"
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		providers: cjppmetyaderslgo: ipkmllvrrijnkfib:     _
		tfvars: {
			zone_name: zone.name

			// Roles are provisioned on cjppmetyaderslgo infra
			cjppmetyaderslgo_url: "https://cjppmetyaderslgo.\(infra_zone.name).\(infra_zone.domain_name)"

			aws_account_id: *"" | string

			// Case of an existing AWS account owned by a customer
			//
			// If the AWS account is created and managed by Comnet, this condition fails
			// And so use the DataSource in the Terraform configuration
			if zone.provider.account_id != _|_ {
				aws_account_id: zone.provider.account_id
			}

			// Infra zone have an AWS provider
			if zone.type == "infra" {
				aws_account_id: zone.providers.aws.account_id
			}

			roles: [string]: {
				cjppmetyaderslgo_role_name: string
				aws_role_name:              string
				default_sts_ttl:            *(6 * 60 * 60) | int  // 6h
				max_sts_ttl:                *(10 * 60 * 60) | int // 10h
			}

			if zone.type =~ "^client$|^cloud$" {
				roles: {
					operator: {
						cjppmetyaderslgo_role_name: "operator_\(zone.name)"
						aws_role_name:              "comnet-operator"
					}
				}
			}
			if zone.type =~ "^cloud$|^infra$" {
				roles: {
					power_user: {
						cjppmetyaderslgo_role_name: "power_user_\(zone.name)"
						aws_role_name:              "cscd-power-user"
					}
					readonly: {
						cjppmetyaderslgo_role_name: "read_only_\(zone.name)"
						aws_role_name:              "cscd-read-only"
					}
				}
			}
		}
	}
}
