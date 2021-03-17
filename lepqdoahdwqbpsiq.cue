package terraform

envs: [string]: {
	zone: _
	configurations: ["psssgdvldainnjre-federate"]: {
		providers: kubernetes: "\(zone.name)": _

		helm: {
			path:         "helm/comnet-servicemonitor"
			release_name: "monitoring-of-monitoring-consumption-federate"
			namespace:    "monitoring-consumption"
			values: {
				fullnameOverride: "servicemonitor-monitoring-consumption-federate"

				servicemonitorMap: {
					"mom-comnet-prometheus-consumption-federate": {
						prometheusZone: "comnet"
						spec: {
							endpoints: [{
								path: "/federate"
								params: {
									"match[]": [
										"up{job=~\"federate-.*\"}",
									]
								}
								port:          "web"
								interval:      "60s"
								scrapeTimeout: "30s"
								relabelings:   [...#PrometheusOperatorRelabelConfig] & [
										{
										replacement: "infra-consumption"
										targetLabel: "cc_prom_source"
									},
								]
							}]
							namespaceSelector: matchNames: [ "monitoring-consumption"]
							selector: matchLabels: app: "kube-prometheus-stack-prometheus"
						}
					}
				}
			}
		}
	}
}
