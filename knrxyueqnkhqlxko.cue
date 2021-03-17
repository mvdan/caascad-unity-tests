package terraform

import (
	tb "comnet.io/trackbone"
)

envs: [string]: {
	zone: _
	configurations: ["nrmnfyizhlmufpht"]: {
		source: *(tb.#GitSource & {
			url: "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/comnet-kube-prometheus-stack.git"
			tag: *"v1-0.0.1" | string
		}) | tb.#GitSource | #LocalSource
		providers: kubernetes: "\(zone.name)": _

		//default helm chart definition
		//When we will be able to deploy v2, uncomment following lines to set v2 helm chart as default
		//helm: path:  *"helm/comnet-kube-prometheus-stack-v2" | string
		//if zone.provider.type == "fe" {
		// if configurations.dcopcpjuuzvxnflo.tfvars.cluster_version =~ "^(v1.15|v1.13)" {
		//  helm: path:  "helm/comnet-kube-prometheus-stack-v1"
		//  source: tag: "v1-0.0.1"
		// }
		//}

		helm: {
			path:         *"helm/comnet-kube-prometheus-stack-v1" | string
			release_name: "nrmnfyizhlmufpht"

			namespace: *"monitoring" | string
			if zone.type == "client" {
				namespace: "comnet-monitoring"
			}

			values: #PrometheusOperatorHelmValues

			if zone.type == "cloud" {
				values: "kube-prometheus-stack": prometheusOperator: {
					serviceMonitor: relabelings: [{
						targetLabel: "cc_prom_source"
						replacement: "cloud-comnet"
					}]
				}
			}
			if zone.type == "client" {
				values: "kube-prometheus-stack": prometheusOperator: {
					serviceMonitor: relabelings: [{
						targetLabel: "comnet_com_prometheus_monitor_scope"
						replacement: "comnet"
					}]
				}
			}
			if zone.type == "infra" {
				values: "kube-prometheus-stack": prometheusOperator: {
					serviceMonitor: relabelings: [{
						targetLabel: "cc_prom_source"
						replacement: "infra-comnet"
					}]
				}
			}
		}
	}
}

#PrometheusOperatorHelmValues: {
	"kube-prometheus-stack": {
		fullnameOverride: "comnet-prometheus"
		commonLabels: "comnet.com/prometheus-monitor": "comnet"

		prometheusOperator: {
			enabled: true
			resources: {
				limits: {
					cpu?:   string
					memory: *"700Mi" | string
				}
				requests: {
					cpu:    *"1m" | string
					memory: *"70Mi" | string
				}
			}
			serviceMonitor: relabelings: [...#PrometheusOperatorRelabelConfig]
			tlsProxy: resources: {
				limits: {
					cpu?:   string
					memory: *"125Mi" | string
				}
				requests: {
					cpu:    *"1m" | string
					memory: *"10Mi" | string
				}
			}
			admissionWebhooks: enabled: true
		}
	}
}

#PrometheusOperatorRelabelConfig: {
	sourceLabels?: [...string]
	separator?:   string
	targetLabel?: string
	regex?:       string
	modulus?:     int
	replacement?: string
	action?:      string
}
