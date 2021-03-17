package terraform

envs: [string]: {
	zone: _
	configurations: ["yoeagsedgebxcgyg"]: {
		providers: kubernetes: "\(zone.name)": _

		helm: {
			path:         "helm/comnet-servicemonitor"
			release_name: "monitoring-of-monitoring-comnet"
			namespace:    "monitoring"
			values: {
				fullnameOverride: "servicemonitor-monitoring"

				servicemonitorMap: {
					"mom-client-prometheus-comnet": {
						prometheusZone: "client"
						spec: {
							endpoints: [{
								path:        "/metrics"
								port:        "web"
								relabelings: [...#PrometheusOperatorRelabelConfig] & [
										{
										replacement: "cloud-comnet"
										targetLabel: "cc_prom_source"
									},
								]
							}]
							namespaceSelector: matchNames: [ "monitoring"]
							selector: matchLabels: app: "kube-prometheus-stack-prometheus"
						}
					}
				}
			}
		}
	}
}
