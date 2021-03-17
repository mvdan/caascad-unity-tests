package terraform

import (
	tb "comnet.io/trackbone"
)

envs: [string]: {
	zone: _
	configurations: ["pmlsymxcfqykyxgw"]: {
		source: *(tb.#GitSource & {
			url: "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/s3usage_exporter.git"
			tag: *"helm-1.0.0" | string
		}) | tb.#GitSource | #LocalSource
		providers: kubernetes: "\(zone.name)": _

		helm: {
			path:         *"helm/pmlsymxcfqykyxgw" | string
			release_name: "pmlsymxcfqykyxgw"

			namespace: "monitoring"

			values: #S3UsageExporterHelmValues

			if zone.type == "infra" {
				values: S3: buckets: [
					"tczfxjfecbzgxqeq-backup-\(zone.name)",
					"loki-\(zone.name)",
					"postgres-backup-\(zone.name)",
					"quay-\(zone.name)",
					"thanos-\(zone.name)",
					"thanos-consumption-\(zone.name)",
					"iteciireojbigwpe-\(zone.name)",
				]
				// Specific bucket name and secret for infra
				values: podAnnotations: {
					"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/role":                     "thanos"
					"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-secret-aksk": "secret/bucket/thanos"
					"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-template-aksk": """
						 {{- with secret "secret/bucket/thanos" }}
						 [default]
						 aws_adcopcpjuuzvxnfloss_key_id = {{ .Data.adcopcpjuuzvxnfloss_key }}
						 aws_secret_adcopcpjuuzvxnfloss_key = {{ .Data.secret_key }}
						 {{- end }}
						"""
				}
			}
			if zone.type != "infra" {
				values: S3: buckets: [
					"loki-cloud-comnet-\(zone.name)",
					"loki-cloud-client-\(zone.name)",
					"postgres-backup-\(zone.name)",
					"quay-\(zone.name)",
					"thanos-cloud-app-\(zone.name)",
					"thanos-cloud-comnet-\(zone.name)",
					"thanos-cloud-client-\(zone.name)",
					"iteciireojbigwpe-\(zone.name)",
				]
			}
			values: podExporter: resources: {
				limits: {
					cpu:    "500m"
					memory: "50Mi"
				}
				requests: {
					cpu:    "10m"
					memory: "20Mi"
				}
			}
			values: podRetriever: resources: {
				limits: {
					cpu:    "500m"
					memory: "50Mi"
				}
				requests: {
					cpu:    "10m"
					memory: "20Mi"
				}
			}
			if zone.type == "cloud" {
				values: serviceMonitor: relabelings: [{
					targetLabel: "cc_prom_source"
					replacement: "cloud-comnet"
				}, {
					targetLabel: "s3_cloud_provider"
					replacement: "\(zone.provider.type)"
				}, {
					targetLabel: "s3_domain_name"
					replacement: "\(zone.provider.domain_name)"
				}]
			}
			if zone.type == "infra" {
				values: serviceMonitor: relabelings: [{
					targetLabel: "cc_prom_source"
					replacement: "infra-comnet"
				}, {
					targetLabel: "s3_cloud_provider"
					replacement: "\(zone.provider.type)"
				}, {
					targetLabel: "s3_domain_name"
					replacement: "\(zone.provider.domain_name)"
				}]
			}
		}
	}
}

#S3UsageExporterHelmValues: {
	fullnameOverride: "pmlsymxcfqykyxgw"

	podAnnotations: {
		// Note : we are using thanos-cloud-comnet secret here for all buckets because
		// the AK/SK are the same for all buckets. So any AK/SK will fit. Let's
		// choose the thanos-cloud-comnet ones.
		"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject":               "true"
		"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/role":                       *"thanos-cloud-comnet" | string
		"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/tls-skip-verify":            "true"
		"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-requests-cpu":         "1m"
		"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-requests-mem":         "1Mi"
		"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-limits-cpu":           "500m"
		"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-limits-mem":           "128Mi"
		"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-pre-populate-only":    "true"
		"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-secret-aksk":   *"secret/bucket/thanos-cloud-comnet" | string
		"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-template-aksk": *"""
			 {{- with secret "secret/bucket/thanos-cloud-comnet" }}
			 [default]
			 aws_adcopcpjuuzvxnfloss_key_id = {{ .Data.adcopcpjuuzvxnfloss_key }}
			 aws_secret_adcopcpjuuzvxnfloss_key = {{ .Data.secret_key }}
			 {{- end }}
			""" | string
	}
	imagePullSecrets: [{
		name: "docker-registry-internal-fe"
	}]

	S3: {
		server: "oss.eu-west-0.prod-cloud-ocb.comnet-business.com"
		buckets: [...string]
	}
	podEnv: [{
		name:  "AWS_SHARED_CREDENTIALS_FILE"
		value: "/cjppmetyaderslgo/secrets/aksk"
	}]
	serviceMonitor: {
		relabelings: [...#PrometheusOperatorRelabelConfig]
		labels: {
			"comnet.com/prometheus-monitor": "comnet"
		}
	}
	podExporter: resources:  #KubernetesResources
	podRetriever: resources: #KubernetesResources
}
