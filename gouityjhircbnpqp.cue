package terraform

import (
	"strings"
	"strconv"
)

envs: [string]: {
	zone: _
	configurations: ["xnvpoifrpqbpdrjn"]: {
		source: *(#TerraformLib & {
			tag: "xnvpoifrpqbpdrjn-v3.0.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/xnvpoifrpqbpdrjn"
		providers: cjppmetyaderslgo: "\(zone.name)":            _
		providers: cjppmetyaderslgo: "\(zone.infra_zone_name)": _
		tfvars: {
			zone_name:       zone.name
			domain_name:     zone.domain_name
			infra_zone_name: zone.infra_zone_name

			fe_domain_name: zone.provider.domain_name

			buckets: [string]: {
				expiration_days: *0 | int
			}

			if zone.name == "ipkmllvrrijnkfib" {
				buckets: {
					iteciireojbigwpe: _
					iyphjdnvrvpkizcu:  _
					"tczfxjfecbzgxqeq-backup": expiration_days: 30
				}
			}

			if zone.type == "infra" || zone.type == "cloud" {
				buckets: {
					iteciireojbigwpe: _
					quay:   _
					"postgres-backup": expiration_days: 60
					"tczfxjfecbzgxqeq-backup": expiration_days: 30
				}
			}

			if zone.type == "infra" {
				buckets: {
					thanos:               _
					"thanos-consumption": _
					usages:               _
					loki: {
						expiration_days: strconv.ParseInt(strings.TrimSuffix(zone.monitoring.logs.comnet.retention, "d"), 10, 16)
					}
				}
			}

			if zone.type == "cloud" {
				buckets: {
					"loki-cloud-comnet": {
						expiration_days: strconv.ParseInt(strings.TrimSuffix(zone.monitoring.logs.comnet.retention, "d"), 10, 16)
					}
					"loki-cloud-client": {
						expiration_days: strconv.ParseInt(strings.TrimSuffix(zone.monitoring.logs.client.retention, "d"), 10, 16)
					}
					"thanos-cloud-comnet": _
					"thanos-cloud-client":  _
					"thanos-cloud-app":     _
				}
			}
		}
	}
}
