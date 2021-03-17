package terraform

envs: [string]: {
	zone: _
	configurations: ["psssgdvldainnjre"]: {
		providers: kubernetes: "\(zone.name)": _

		helm: {
			path:         "helm/comnet-servicemonitor"
			release_name: "monitoring-of-monitoring-consumption"
			namespace:    "monitoring-consumption"
			values: {
				fullnameOverride: "servicemonitor-monitoring-consumption"

				servicemonitorMap: {
					"mom-comnet-prometheus-consumption": {
						prometheusZone: "comnet"
						spec: {
							endpoints: [{
								path:        "/metrics"
								port:        "web"
								relabelings: [...#PrometheusOperatorRelabelConfig] & [
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
					"mom-comnet-alertmanager-consumption": {
						prometheusZone: "comnet"
						spec: {
							endpoints: [{
								path:        "/metrics"
								port:        "web"
								relabelings: [...#PrometheusOperatorRelabelConfig] & [
										{
										replacement: "infra-consumption"
										targetLabel: "cc_prom_source"
									},
								]
							}]
							namespaceSelector: matchNames: [ "monitoring-consumption"]
							selector: matchLabels: app: "kube-prometheus-stack-alertmanager"
						}
					}
				}
			}
		}
	}
}
