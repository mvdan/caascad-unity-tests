package terraform

envs: [string]: {
	zone: _
	configurations: ["govdevaxtdjwwawc-federate"]: {
		providers: kubernetes: "\(zone.name)": _

		helm: {
			path:         "helm/comnet-servicemonitor"
			release_name: "monitoring-of-monitoring-app-federate"
			namespace:    "monitoring-app"
			values: {
				fullnameOverride: "servicemonitor-monitoring-app-federate"

				servicemonitorMap: {
					"mom-comnet-prometheus-app-federate": {
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
								relabelings: [...#PrometheusOperatorRelabelConfig] & [
									{
										replacement: "cloud-app"
										targetLabel: "cc_prom_source"
									},
								]
							}]
							namespaceSelector: matchNames: ["monitoring-app"]
							selector: matchLabels: app: "kube-prometheus-stack-prometheus"
						}
					}
				}
			}
		}
	}
}
