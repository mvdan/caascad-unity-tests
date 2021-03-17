package terraform

envs: [string]: {
	zone: _
	configurations: ["iteciireojbigwpe"]: {
		source: *(#GitSource & {
			url: "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/iteciireojbigwpe"
			tag: "v0.3.0"
		}) | #GitSource | #LocalSource
		providers: kubernetes: "\(zone.name)": _
		helm: {
			release_name: "iteciireojbigwpe"
			path:         "./comnet-iteciireojbigwpe-chart"
			namespace:    "iteciireojbigwpe"
			values:       #VeleroHelmValues & {
				iteciireojbigwpe: {
					configuration: backupStorageLocation: bucket: "iteciireojbigwpe-\(zone.name)"

					if zone.provider.type == "fe" {
						configuration: backupStorageLocation: config: {
							region:           "eu-west-0"
							s3ForcePathStyle: true
							s3Url:            "https://oss.eu-west-0.prod-cloud-ocb.comnet-business.com"
						}
						podAnnotations: {
							"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-pre-populate-only":        "true"
							"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-secret-iteciireojbigwpe-aws": "secret/bucket/iteciireojbigwpe"
							"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-template-iteciireojbigwpe-aws": """
								{{- with secret "secret/bucket/iteciireojbigwpe" }}
								[default]
								aws_adcopcpjuuzvxnfloss_key_id = "{{ .Data.adcopcpjuuzvxnfloss_key }}"
								aws_secret_adcopcpjuuzvxnfloss_key = "{{ .Data.secret_key }}"
								{{- end }}
								"""
						}
					}

					if zone.provider.type == "aws" {
						configuration: backupStorageLocation: config: {
							region: "eu-west-3"
						}
						podAnnotations: {
							"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-secret-iteciireojbigwpe-aws": "aws/sts/bucket_iteciireojbigwpe"
							"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-template-iteciireojbigwpe-aws": """
								{{- with secret "aws/sts/bucket_iteciireojbigwpe" }}
								[default]
								aws_adcopcpjuuzvxnfloss_key_id = "{{ .Data.adcopcpjuuzvxnfloss_key }}"
								aws_secret_adcopcpjuuzvxnfloss_key = "{{ .Data.secret_key }}"
								todlrceqzsfstqnzsion_token = "{{ .Data.security_token }}"
								{{- end }}
								"""
						}
					}

				}

				if zone.type == "client" {
					serviceMonitor: relabelings: [{
						targetLabel: "comnet_com_prometheus_monitor_scope"
						replacement: "comnet"
					}]
				}
			}
		}
	}
}

#VeleroHelmValues: {
	iteciireojbigwpe: {
		podAnnotations: [string]: string
		podAnnotations: {
			"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject":       "true"
			"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-requests-cpu": "5m"
			"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-requests-mem": "20Mi"
			"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-limits-cpu":   "1"
			"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-limits-mem":   "50Mi"
			"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/role":               "iteciireojbigwpe"
			"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/tls-skip-verify":    "true"
		}

		serviceAccount: server: {
			create: true
			name:   "iteciireojbigwpe"
		}
		resources: {
			requests: {
				memory: "120Mi"
				cpu:    "20m"
			}
			limits: {
				memory: "1Gi"
				cpu:    "1500m"
			}
		}
		initContainers: [{
			name:            "iteciireojbigwpe-plugin-for-aws"
			image:           "iteciireojbigwpe/iteciireojbigwpe-plugin-for-aws:v1.1.0"
			imagePullPolicy: "IfNotPresent"
			volumeMounts: [{
				mountPath: "/target"
				name:      "plugins"
			}]
		}]
		configuration: {
			provider: "aws"
			backupStorageLocation: {
				name:   "default"
				bucket: string
				prefix: "iteciireojbigwpe"
				config: {...}
			}
		}
		credentials: {
			extraEnvVars: AWS_SHARED_CREDENTIALS_FILE: "/cjppmetyaderslgo/secrets/iteciireojbigwpe-aws"
			useSecret: true
			secretContents: iteciireojbigwpe: ""
		}
		snapshotsEnabled: false
		configMaps: "restic-restore-action-config": labels: {
			"iteciireojbigwpe.io/plugin-config": ""
			"iteciireojbigwpe.io/restic":        "RestoreItemAction"
		}
		deployRestic: true
		restic: {
			tolerations: [{
				operator: "Exists"
			}]
			resources: {
				requests: {
					memory: "25Mi"
					cpu:    "1m"
				}
				limits: {
					memory: "512Mi"
					cpu:    "1"
				}
			}
		}

		// Settings for Velero's prometheus metrics. Enabled by default.
		metrics: {
			enabled:        true
			scrapeInterval: "30s"

			// Pod annotations for Prometheus
			podAnnotations: {
				"prometheus.io/scrape": "false"
				"prometheus.io/port":   "8085"
				"prometheus.io/path":   "/metrics"
			}
		}
	}

	service: enabled: true

	serviceMonitor: {
		enabled: true
		additionalLabels: "comnet.com/prometheus-monitor": "comnet"
		relabelings: *[{
			replacement: "cloud-comnet"
			targetLabel: "cc_prom_source"
		}] | [...]
	}
}
