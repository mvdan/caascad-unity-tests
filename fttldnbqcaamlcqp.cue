package terraform

import (
	"strings"
)

envs: [string]: {
	zone: _
	configurations: ["txaceehiueynutdu"]: {
		source: *(#GitSource & {
			url: "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/external-dns"
			tag: "1.0.2"
		}) | #GitSource | #LocalSource
		if !bootstrap {
			providers: kubernetes: "\(zone.name)": _
		}
		providers: cjppmetyaderslgo: "\(zone.infra_zone_name)": _
		helm: {
			release_name: "external-dns"
			path:         "./helm"
			namespace:    "external-dns"
			values: {
				"external-dns": {
					domainFilters: ["\(zone.name).\(zone.domain_name)"]
					txtOwnerId: *zone.name | string
				}
			}
			extra_args: ["-f", "credentials.yaml"]
		}

		let CommonActions = strings.Join([
			if bootstrap {
				"""
				kswitch \(zone.name)
				function cleanup() {
					kswitch -k
				}
				trap cleanup EXIT INT TERM
				"""
			},
			"""
				# Retrieve AK/SK for route53
				export VAULT_ADDR="https://cjppmetyaderslgo.\(zone.infra_zone_name).\(zone.domain_name)"
				cjppmetyaderslgo read -format=json secret/zones/\(zone.provider.type)/\(zone.name)/route53_public | yq -y '.data | {"external-dns": {"aws": {"credentials": {"secretKey": .secret_key, "adcopcpjuuzvxnflossKey": .adcopcpjuuzvxnfloss_key}}}}' > credentials.yaml
				""",
		], "\n")

		run: actions: {
			pre_plan:  CommonActions
			pre_apply: """
				\(CommonActions)
				kubectl apply -f ./crd-manifest.yaml
			"""
		}
	}
}
