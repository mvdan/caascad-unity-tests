package terraform

import (
	"list"
	"strings"
	tb "comnet.io/trackbone"
)

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: [ConfigName= =~"^ingress_controller_(private|public)$"]: {
		let IngressType = strings.Split(ConfigName, "_")[strings.Count(ConfigName, "_")]
		source: *(tb.#GitSource & {
			url: "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/ingress-controller.git"
			tag: *"v1.0.0" | string
		}) | tb.#GitSource | #LocalSource
		helm: {
			path:         "./helm"
			release_name: "ingress-nginx-\(IngressType)"
			namespace:    "ingress-nginx-\(IngressType)"
			extra_args: ["-f", "overrides.yaml"]
			values: "nginx-ingress": {
				controller: {
					replicaCount: 2
					ingressClass: "ingress-nginx-\(IngressType)"
					publishService: {
						enabled: true
					}
					metrics: {
						enabled: true
						serviceMonitor: {
							enabled: true
							additionalLabels: {"comnet.com/prometheus-monitor": "comnet"}
						}
					}
					if zone.provider.type == "aws" {
						service: {
							if IngressType == "private" {
								//The NAT GW is needed because the blackbox exporter has probes for services behind the private ingress
								loadBalancerSourceRanges: list.FlattenN([ ipam.natgw[infra_zone.name], ipam.vpn.comnet, ipam.natgw[zone.name]], 1)
							}
							annotations: {
								"service.beta.kubernetes.io/aws-load-balancer-backend-protocol":                  "tcp"
								"service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled": "true"
								"service.beta.kubernetes.io/aws-load-balancer-type":                              "nlb"
								"external-dns.alpha.kubernetes.io/hostname":                                      "\(IngressType).\(zone.name).\(zone.domain_name)"
							}
						}
					}
				}
				tcp: [string]: string
				tcp: {
					if zone.name != "ipkmllvrrijnkfib" && zone.name != "ipkmllvrrijnkfib-stg" {
						if IngressType == "private" {
							"2222": "concourse-infra/concourse-web-worker-gateway:2222"
						}
						if IngressType == "public" && zone.type == "cloud" {
							"2222": "concourse/concourse-web-worker-gateway:2222"
							"22":   "gitea/gitea-ssh:22"
						}
						if IngressType == "private" && zone.type == "infra" {
							"22": "gitea/gitea-ssh:22"
						}
					}
				}
			}
		}
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		if !bootstrap {
			providers: kubernetes: "\(zone.name)": _
		}
		env_vars: {
			AWS_DEFAULT_REGION: envs[infra_zone.name].configurations.dtmyfegilaxrvzuc.tfvars.dtmyfegilaxrvzuc_region_name
			SD_TABLE_NAME:      envs[infra_zone.name].configurations.dtmyfegilaxrvzuc.tfvars.dtmyfegilaxrvzuc_table_name
			VAULT_STS_ROLE:     "power_user_\(infra_zone.name)"
			VAULT_ADDR:         "https://cjppmetyaderslgo.\(infra_zone.name).\(infra_zone.domain_name)"
			INFRA_ZONE_NAME:    infra_zone.name
		}
		run: actions: {
			let PreCommand = strings.Join([
				"""
				sd get objects > objects.json 2>/dev/null
				cue import -f -R objects.json -p ingresscontroller -l '"Discovery"'
				cue export -e overrides -t zone_name=\(zone.name) -t zone_type=\(zone.type) -t zone_provider=\(zone.provider.type) -t ingress_type=\(IngressType)> overrides.yaml
				""",
				if bootstrap {
					"""
						kswitch \(zone.name)
						function cleanup() {
							kswitch -k
						}
						trap cleanup EXIT INT TERM
						"""
				},
			], "\n")
			pre_plan:  PreCommand
			pre_apply: PreCommand
		}
	}
}
