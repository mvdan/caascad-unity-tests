package terraform

import (
	"strings"
	"comnet.io/zones"
)

let Zones = zones.zones

envs: [string]: {
	zone: _
	configurations: ["tshzetpznsktkvxv"]: {
		source: *(#TerraformLib & {
			tag: "tshzetpznsktkvxv-v1.1.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/tshzetpznsktkvxv"
		providers: cjppmetyaderslgo: "\(zone.infra_zone_name)": _
		tfvars: {
			zone_name:          zone.name
			domain_name:        zone.domain_name
			infra_zone_name:    zone.infra_zone_name
			lb_name:            *"public" | string
			vpc_name:           configurations.ekcfqfyldqagosjs.tfvars.router_name
			vpcep_service_name: *"cscd-vpceps" | strings.MaxRunes(16)
			let Permissions = [for child_zone in zone.child_zone_names if Zones[child_zone].provider.type == "fe" {"iam:domain::\(Zones[child_zone].provider.domain)"}]
			vpcep_service_permissions: *Permissions | [...string]
			vpcep_approved_endpoints: [...string]
		}
	}
}
