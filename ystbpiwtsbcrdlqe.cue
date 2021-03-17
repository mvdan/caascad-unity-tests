package terraform

envs: [string]: {
	zone: _
	configurations: ["omqqscnuljhspdwm"]: {
		providers: kubernetes: "\(zone.name)": _

		helm: {
			path:         "helm/comnet-servicemonitor"
			release_name: "monitoring-of-monitoring-comnet"
			namespace:    "monitoring"
			values: {
				fullnameOverride: "servicemonitor-monitoring"

				servicemonitorMap: {
					"mom-consumption-prometheus-comnet": {
						prometheusZone: "consumption"
						spec: {
							endpoints: [{
								path:        "/metrics"
								port:        "web"
								relabelings: [...#PrometheusOperatorRelabelConfig] & [
										{
										replacement: "infra-comnet"
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
