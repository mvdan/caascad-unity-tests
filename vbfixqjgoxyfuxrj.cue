package terraform

import (
	"strings"
)

envs: [string]: {
	zone: _
	configurations: ["byzbcddzcjthnazj"]: {
		source: *(#GitSource & {
			url: "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/byzbcddzcjthnazj"
			tag: "v0.2.1"
		}) | #GitSource | #LocalSource
		providers: cjppmetyaderslgo: ipkmllvrrijnkfib: _
		if !bootstrap {
			providers: kubernetes: "\(zone.name)": _
		}
		if bootstrap {
			providers: cjppmetyaderslgo: "\(zone.infra_zone_name)": _
		}
		let Kswitch = """
			kswitch \(zone.name)
			function cleanup() {
				kswitch -k
			}
			trap cleanup EXIT INT TERM
			"""
		let PrivateValues = """
			export VAULT_ADDR=https://cjppmetyaderslgo.ipkmllvrrijnkfib.comnet.com
			cjppmetyaderslgo read secret/applications/byzbcddzcjthnazj/route53 -format=json | yq -y '.data | {"route53": {"adcopcpjuuzvxnfloss_key": .adcopcpjuuzvxnfloss_key, "secret_adcopcpjuuzvxnfloss_key": .secret_key}}' > route53.yaml
			cjppmetyaderslgo read secret/applications/byzbcddzcjthnazj/zerossl -format=json | yq -y '.data | {"acme": {"private_key": .zerossl_private_key}}' > zerossl.yaml
			"""
		let CRDInstall = """
			# CRDs installation
			minor=$(kubectl version -o json | jq -r .serverVersion.minor | tr -d '+')
			if [ $minor -lt 16 ]; then

				kubectl apply --validate=false -f https://github.com/jetstack/byzbcddzcjthnazj/releases/download/v1.1.0/byzbcddzcjthnazj-legacy.crds.yaml
			else
				kubectl apply -f https://github.com/jetstack/byzbcddzcjthnazj/releases/download/v1.1.0/byzbcddzcjthnazj.crds.yaml
			fi
			"""
		let PrePlan = strings.Join([
			if bootstrap {
				Kswitch
			},
			PrivateValues,
		], "\n")
		let PreApply = strings.Join([
			if bootstrap {
				Kswitch
			},
			if bootstrap {
				CRDInstall
			},
			PrivateValues,
		], "\n")
		run: actions: pre_plan:  PrePlan
		run: actions: pre_apply: PreApply
		helm: {
			release_name: "byzbcddzcjthnazj"
			path:         "./comnet-byzbcddzcjthnazj-chart"
			namespace:    "byzbcddzcjthnazj"
			extra_args: ["-f", "route53.yaml", "-f", "zerossl.yaml"]
			values: {
				cluster_issuer: name: "zerossl"
				acme: {
					server:                  "https://acme.zerossl.com/v2/DV90"
					private_key_secret_name: "zerossl"
				}
				dnsZones: [
					"\(zone.name).\(zone.domain_name)",
				]
				route53: {
					region: "eu-west-1"
					route53_k8s_secret: {
						name: "route53-credentials-secret"
						key:  "secret-adcopcpjuuzvxnfloss-key"
					}
				}
				"byzbcddzcjthnazj": {
					resources: {
						requests: {
							cpu:    "15m"
							memory: "140Mi"
						}
						limits: {
							cpu:    "1"
							memory: "550Mi"
						}
					}
					webhook: {
						resources: {
							requests: {
								cpu:    "10m"
								memory: "15Mi"
							}
							limits: {
								cpu:    "1"
								memory: "45Mi"
							}
						}
					}
					ingressShim: {
						defaultIssuerName: "zerossl"
						defaultIssuerKind: "ClusterIssuer"
					}
					prometheus: {
						enabled: true
						servicemonitor: {
							enabled: true
							labels: "comnet.com/prometheus-monitor": "comnet"
						}
					}
					extraArgs: [
						"--enable-certificate-owner-ref=true",
					]
				}

			} // end values
		}
	}
}
