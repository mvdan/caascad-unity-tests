package terraform

import (
	z "comnet.io/zones"
)

let AWSAccounts = z.aws_accounts

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: [Name= =~"^wbeglgblcrlfskiy"]: {
		source: *(#TerraformLib & {
			tag: "wbeglgblcrlfskiy-v1.3.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/wbeglgblcrlfskiy"
		providers: cjppmetyaderslgo: "ipkmllvrrijnkfib": _
		tfvars: {
			zone_name: zone.name
			// For a client or cloud zone deployed on AWS
			aws_account_name:        *zone.provider.account_name | string
			cjppmetyaderslgo_aws_role:          *"account_bootstrap_\(zone.name)" | string
			trusted_aws_account_ids: *[z.aws_accounts.comnet_prod.account_id, infra_zone.providers.aws.account_id] | [...string]

			// For now infra zones are not deployed on AWS but have adcopcpjuuzvxnfloss to an AWS account
			// referenced in the `providers.aws` attribute.
			if zone.type == "infra" {
				aws_account_name: zone.providers.aws.account_name
				cjppmetyaderslgo_aws_role:   "account_bootstrap_\(zone.providers.aws.account_id)"
				trusted_aws_account_ids: [z.aws_accounts.comnet_prod.account_id, zone.providers.aws.account_id]
			}

			// Specific to ipkmllvrrijnkfib
			if Name == "wbeglgblcrlfskiy_comnet_orga" {
				aws_account_name: AWSAccounts.comnet_orga.account_name
				cjppmetyaderslgo_aws_role:   "account_bootstrap_\(AWSAccounts.comnet_orga.account_id)"
				trusted_aws_account_ids: [z.aws_accounts.comnet_prod.account_id]
			}
		}
	}
}
