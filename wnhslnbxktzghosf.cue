package terraform

import (
	"strings"
	"strconv"
)

envs: [string]: {
	zone: _
	configurations: ["vbhsacluzdvcwsjt"]: {
		source: *(#TerraformLib & {
			tag: "vbhsacluzdvcwsjt-v2.0.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/vbhsacluzdvcwsjt"
		providers: cjppmetyaderslgo: "\(zone.name)":            _
		providers: cjppmetyaderslgo: "\(zone.infra_zone_name)": _
		providers: cjppmetyaderslgo: "ipkmllvrrijnkfib":        _
		tfvars: {
			zone_name:       zone.name
			domain_name:     zone.domain_name
			infra_zone_name: zone.infra_zone_name

			aws_region: zone.provider.region

			cjppmetyaderslgo_aws_role:     "power_user_\(zone.name)"
			cjppmetyaderslgo_aws_iam_role: "account_bootstrap_\(zone.name)"

			buckets: [string]: {
				expiration_days: *0 | int
				static_creds:    *false | bool
			}

			buckets: [=~"^thanos|^loki|^quay"]: {
				static_creds: true
			}

			if zone.name == "ipkmllvrrijnkfib" {
				buckets: {
					iteciireojbigwpe: _
					"tczfxjfecbzgxqeq-backup": expiration_days: 30
				}
			}

			if zone.type == "infra" || zone.type == "cloud" {
				buckets: {
					iteciireojbigwpe: _
					quay:             _
					"postgres-backup": expiration_days:         60
					"tczfxjfecbzgxqeq-backup": expiration_days: 30
				}
			}

			if zone.type == "infra" {
				buckets: {
					thanos:               _
					"thanos-consumption": _
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
					"thanos-cloud-client": _
					"thanos-cloud-app":    _
				}
			}
		}
	}
}
