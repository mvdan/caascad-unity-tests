package terraform

import (
	"comnet.io/zones"
)

let Zones = zones.zones

envs: [string]: {
	zone: _
	configurations: ["tczfxjfecbzgxqeq-cjppmetyaderslgo-ipkmllvrrijnkfib"]: {
		source: *(#TerraformLib & {
			tag: "tczfxjfecbzgxqeq-cjppmetyaderslgo-ipkmllvrrijnkfib-v3.6.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/tczfxjfecbzgxqeq-cjppmetyaderslgo-ipkmllvrrijnkfib"
		providers: cjppmetyaderslgo: "\(zone.name)": _
		tfvars: {
			zone_name:   zone.name
			domain_name: zone.domain_name
			infra_zones: {
				for _, z in Zones
				if z.type == "infra" {
					"\(z.name)": {
						realm_name: *z.name | string
						if z.name == "infra-zwtkxvyalrulrfjt" {
							realm_name: "Comnet"
						}
						domain_name: z.domain_name
					}
				}
			}
		}
	}
}
