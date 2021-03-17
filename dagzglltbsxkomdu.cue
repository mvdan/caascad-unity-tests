package terraform

envs: [string]: {
	zone: _
	configurations: ["govdevaxtdjwwawc"]: {
		providers: kubernetes: "\(zone.name)": _

		helm: {
			path:         "helm/comnet-servicemonitor"
			release_name: "monitoring-of-monitoring-app"
			namespace:    "monitoring-app"
			values: {
				fullnameOverride: "servicemonitor-monitoring-app"

				servicemonitorMap: {
					"mom-comnet-prometheus-app": {
						prometheusZone: "comnet"
						spec: {
							endpoints: [{
								path:        "/metrics"
								port:        "web"
								relabelings: [...#PrometheusOperatorRelabelConfig] & [
										{
										replacement: "cloud-app"
										targetLabel: "cc_prom_source"
									},
								]
							}]
							namespaceSelector: matchNames: [ "monitoring-app"]
							selector: matchLabels: app: "kube-prometheus-stack-prometheus"
						}
					}
					"mom-comnet-alertmanager-app": {
						prometheusZone: "comnet"
						spec: {
							endpoints: [{
								path:        "/metrics"
								port:        "web"
								relabelings: [...#PrometheusOperatorRelabelConfig] & [
										{
										replacement: "cloud-app"
										targetLabel: "cc_prom_source"
									},
								]
							}]
							namespaceSelector: matchNames: [ "monitoring-app"]
							selector: matchLabels: app: "kube-prometheus-stack-alertmanager"
						}
					}
				}
			}
		}
	}
}
