package terraform

envs: [string]: {
	zone: _
	configurations: ["pmlsymxcfqykyxgw-servicemonitor"]: {
		providers: kubernetes: "\(zone.name)": _

		helm: {
			path:         "helm/comnet-servicemonitor"
			release_name: "servicemonitor-s3usage"
			namespace:    "monitoring-client"
			values: {
				fullnameOverride: "servicemonitor-s3usage"

				servicemonitorMap: {
					"s3usage-federation": {
						prometheusZone: "client"
						spec: {
							endpoints: [{
								path: "/federate"
								params: {
									"match[]": [
										"{__name__=~\"s3_bucket.*\", s3_bucket_name=~\"loki-cloud-client-\(zone.name)|thanos-cloud-app-\(zone.name)|quay-\(zone.name)\"}",
									]
								}
								port: "web"
								metricRelabelings: [...#PrometheusOperatorRelabelConfig] & [{
									regex:  "instance|pod|service|job|namespace|endpoint|exported_.*"
									action: "labeldrop"
								}, {
									regex:       "loki.*"
									replacement: "Logs"
									sourceLabels: ["s3_bucket_name"]
									targetLabel: "grafana_dashboard_panel_name"
								}, {
									regex:       "thanos.*"
									replacement: "Metrics"
									sourceLabels: ["s3_bucket_name"]
									targetLabel: "grafana_dashboard_panel_name"
								}, {
									regex:       "quay.*"
									replacement: "Docker images"
									sourceLabels: ["s3_bucket_name"]
									targetLabel: "grafana_dashboard_panel_name"
								}]
							}]

							namespaceSelector: matchNames: ["monitoring"]
							selector: matchLabels: app: "kube-prometheus-stack-prometheus"
						}
					}
				}
			}
		}
	}
}
