package terraform

envs: [string]: {
	zone: _
	configurations: ["isdvrilyginwbowp"]: {
		providers: kubernetes: "\(zone.name)": _

		helm: {
			path:         "helm/comnet-servicemonitor"
			release_name: "monitoring-of-monitoring-client"
			namespace:    "monitoring-client"
			values: {
				fullnameOverride: "servicemonitor-monitoring-client"

				servicemonitorMap: {
					"mom-comnet-prometheus-client": {
						prometheusZone: "comnet"
						spec: {
							endpoints: [{
								path:        "/metrics"
								port:        "web"
								relabelings: [...#PrometheusOperatorRelabelConfig] & [
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

					"mom-comnet-alertmanager-client": {
						prometheusZone: "comnet"
						spec: {
							endpoints: [{
								path:        "/metrics"
								port:        "web"
								relabelings: [...#PrometheusOperatorRelabelConfig] & [
										{
										replacement: "cloud-client"
										targetLabel: "cc_prom_source"
									},
								]
							}]
							namespaceSelector: matchNames: [ "monitoring-client"]
							selector: matchLabels: app: "kube-prometheus-stack-alertmanager"
						}
					}
					"mom-comnet-grafana-client": {
						prometheusZone: "comnet"
						spec: {
							endpoints: [{
								path:        "/metrics"
								port:        "service"
								relabelings: [...#PrometheusOperatorRelabelConfig] & [
										{
										replacement: "cloud-client"
										targetLabel: "cc_prom_source"
									},
								]
							}]
							namespaceSelector: matchNames: [ "monitoring-client"]
							selector: matchLabels: "app.kubernetes.io/name": "grafana"
						}
					}
				}
			}
		}
	}
}
