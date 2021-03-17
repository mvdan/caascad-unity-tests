package terraform

import (
	z "comnet.io/zones"
)

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["cjppmetyaderslgo_aws_sts_ipkmllvrrijnkfib"]: {
		source: *(#TerraformLib & {
			tag: "cjppmetyaderslgo_aws_sts_ipkmllvrrijnkfib-v1.3.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/cjppmetyaderslgo_aws_sts_ipkmllvrrijnkfib"
		providers: cjppmetyaderslgo: "\(zone.name)": _
		tfvars: {
			zone_name:   zone.name
			domain_name: zone.domain_name
			aws_account_map: {
				for a in z.aws_accounts
				if a.account_id != _|_ {
					"\(a.account_id)": {
						account_name: a.account_name
						account_id:   a.account_id
					}
				}
			}
		}
	}
}
