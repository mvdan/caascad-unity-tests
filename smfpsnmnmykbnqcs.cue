package terraform

import (
	tb "comnet.io/trackbone"
)

#ComnetServicemonitorHelmConfig: tb.#HelmConfig & {
	source: *(tb.#GitSource & {
		url: "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/comnet-servicemonitor.git"
		tag: *"v1-0.0.1" | string
	}) | tb.#GitSource | #LocalSource
	helm: {
		path:   "helm/comnet-servicemonitor"
		values: #ComnetServicemonitorHelmValues
	}
}

#ComnetServicemonitorHelmValues: {
	fullnameOverride?: string

	servicemonitorMap: {
		[string]: {
			prometheusZone: "comnet" | "client" | "app" | "consumption"
			labels: {...}
			spec: {
				jobLabel?: string
				endpoints: [...{
					path?: string
					params?: {
						"match[]": [...string]
					}
					port?:          string
					interval?:      string
					scrapeTimeout?: string
					honorLabels?:   false | true
					relabelings?: [...#PrometheusOperatorRelabelConfig]
					metricRelabelings?: [...#PrometheusOperatorRelabelConfig]
				}]
				namespaceSelector?: {
					matchNames: [...string]
				}
				selector: matchLabels: {...}
			}
		}
	}
}
