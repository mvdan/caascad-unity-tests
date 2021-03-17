package terraform

envs: [string]: {
	zone: _
	configurations: ["isdvrilyginwbowp-federate"]: {
		providers: kubernetes: "\(zone.name)": _

		helm: {
			path:         "helm/comnet-servicemonitor"
			release_name: "monitoring-of-monitoring-client-federate"
			namespace:    "monitoring-client"
			values: {
				fullnameOverride: "servicemonitor-monitoring-client-federate"

				servicemonitorMap: {
					"mom-comnet-prometheus-client-federate": {
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
										replacement: "cloud-client"
										targetLabel: "cc_prom_source"
									},
								]
							}]
							namespaceSelector: matchNames: [ "monitoring-client"]
							selector: matchLabels: app: "kube-prometheus-stack-prometheus"
						}
					}
				}
			}
		}
	}
}
