package terraform

import (
	z "comnet.io/zones"
)

envs: [string]: {
	zone: _
	configurations: ["feaotlcttwmxdbdh"]: {
		source: *(#TerraformLib & {
			tag: "feaotlcttwmxdbdh-v1.0.1"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/feaotlcttwmxdbdh"
		providers: cjppmetyaderslgo: "\(zone.name)": _

		tfvars: {
			tenant_ids: [ for _, s in z.azure_subscriptions if s.subscription_name =~ "^comnet_.*" {s.tenant_id}]
			zone_name: zone.name
		}
	}
}
