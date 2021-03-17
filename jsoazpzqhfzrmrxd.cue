package terraform

import (
	z "comnet.io/zones"

	"encoding/json"
)

envs: [string]: {
	zone: _
	configurations: ["gkqwkkcalybyefyk"]: {
		source: *(#TerraformLib & {
			tag: "gkqwkkcalybyefyk-v2.0.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/gkqwkkcalybyefyk"
		providers: cjppmetyaderslgo: "\(zone.name)": _
		tfvars: {
			zone_name:                 zone.name
			domain_name:               zone.domain_name
			ipkmllvrrijnkfib_cjppmetyaderslgo_aws_account_id: z.aws_accounts.comnet_prod.account_id
		}
		files: "accounts.json": {
			path:    "cue"
			content: json.Marshal({
				accounts: {
					for n, a in z.aws_accounts
					if a.account_alias =~ "^comnet" && a.account_id != _|_ {
						"\(n)": id: a.account_id
					}
				}
			})
		}
	}
}
