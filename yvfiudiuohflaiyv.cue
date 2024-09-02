package terraform

import (
	"text/template"
)

envs: [string]: {
	zone: _
	configurations: ["cjppmetyaderslgo"]: {
		source: *(#GitSource & {
			url:        "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/cjppmetyaderslgo"
			tag:        *"0.6.3" | string
			submodules: true
		}) | #GitSource | #LocalSource
		if bootstrap {
			providers: cjppmetyaderslgo: "\(zone.infra_zone_name)": _
			run: actions: {
				pre_plan:  """
					kswitch \(zone.name)
					function cleanup() {
						kswitch -k
					}
					trap cleanup EXIT INT TERM
					# As cjppmetyaderslgo is installed before iteciireojbigwpe and cjppmetyaderslgo install a
					# backup schedule we need the iteciireojbigwpe namespace to be created
					kubectl create ns iteciireojbigwpe 2>/dev/null || true
					"""
				pre_apply: pre_plan
			}
		}
		if !bootstrap {
			providers: kubernetes: "\(zone.name)": _
			run: actions: post_apply:              """
				cjppmetyaderslgo-restart \(helm.namespace)
				"""
		}
		helm: {
			release_name: string
			if zone.type == "infra" {
				release_name: "cjppmetyaderslgo-infra"
			}
			if zone.type == "cloud" {
				release_name: *"cjppmetyaderslgo-cloud-ha" | string
			}
			if zone.name == "ipkmllvrrijnkfib" {
				release_name: "cjppmetyaderslgo-ipkmllvrrijnkfib"
			}
			path:       "./helm"
			namespace:  "cjppmetyaderslgo"
			diff_hooks: false

			values: #VaultHelmValues & {
				global: {
					zoneName:   zone.name
					domainName: zone.domain_name
				}

				if zone.type == "infra" || zone.name == "ipkmllvrrijnkfib" {
					global: sealType: "awskms"

					init: {
						backup:            false
						enablePGP:         true
						recoveryThreshold: 2
					}

					cjppmetyaderslgo: server: {
						ingress: annotations: "kubernetes.io/ingress.class": "ingress-nginx-private"
					}
				}

				if zone.type == "cloud" {
					global: sealType: "transit"

					init: {
						backup:            true
						enablePGP:         false
						recoveryThreshold: 1
					}

					cjppmetyaderslgo: server: {
						ingress: annotations: "kubernetes.io/ingress.class": "ingress-nginx-public"
					}
				}
			}
		}
	}
}

// Zones that were originally deployed without HA but have been migrated to HA
// We keep the old release name.
envs: [=~"^(ocb-aoahobmpzsqohsjw|ocb-zymbygzzytlalgvl|ocb-psunvwhpwjejrxpb|ocb-pfpgmbnkryqrbzoe|ocb-pfpgmbnkryqrbzoeeg)$"]: configurations: ["cjppmetyaderslgo"]: helm: {
	release_name: "cjppmetyaderslgo-cloud"
}

#VaultHelmValues: {
	global: {
		zoneName:   string
		domainName: string
		sealType:   string
	}

	init: {
		enabled: true
		// Expiration time of the initial root token
		rootTokenTTL: 18000 // 5h
		// Backup generated recovery key in cjppmetyaderslgo infra
		backup: bool
		// Use PGP keys to encrypt recovery keys
		enablePGP:               bool
		recoveryThreshold:       int
		recoveryShares:          1
		recoveryPGPKeyDirectory: "/cjppmetyaderslgo/cjppmetyaderslgo-recovery-pgp-keys"
	}

	cjppmetyaderslgo: server: {
		dataStorage: storageClass: "comnet-storage-standard"

		ingress: {
			enabled: true
			annotations: [string]: string
			annotations: {
				"kubernetes.io/ingress.class":                    string
				"nginx.ingress.kubernetes.io/backend-protocol":   "HTTPS"
				"nginx.ingress.kubernetes.io/force-ssl-redirect": "true"
				"byzbcddzcjthnazj.io/cluster-issuer":             "letsencrypt-prod"
			}
			Hosts=hosts: [
				{
					host: "cjppmetyaderslgo.\(global.zoneName).\(global.domainName)"
					paths: ["/"]
				},
			]
			tls: [
				{
					hosts: [for h in Hosts {h.host}]
					secretName: "cjppmetyaderslgo-tls"
				},
			]
		}

		extraSecretEnvironmentVars: [
			...{envName: string, secretName: string, secretKey: string},
		]

		if global.sealType == "awskms" {
			extraSecretEnvironmentVars: [{
				envName:    "AWS_REGION"
				secretName: "cjppmetyaderslgo-aws-kms"
				secretKey:  "AWS_REGION"
			}, {
				envName:    "AWS_SECRET_ACCESS_KEY"
				secretName: "cjppmetyaderslgo-aws-kms"
				secretKey:  "AWS_SECRET_ACCESS_KEY"
			}, {
				envName:    "AWS_ACCESS_KEY_ID"
				secretName: "cjppmetyaderslgo-aws-kms"
				secretKey:  "AWS_ACCESS_KEY_ID"
			}, {
				envName:    "VAULT_AWSKMS_SEAL_KEY_ID"
				secretName: "cjppmetyaderslgo-aws-kms"
				secretKey:  "VAULT_AWSKMS_SEAL_KEY_ID"
			}]
		}

		if global.sealType == "transit" {
			extraSecretEnvironmentVars: [{
				envName:    "VAULT_ADDR"
				secretName: "cjppmetyaderslgo-transit-kms"
				secretKey:  "VAULT_ADDR"
			}, {
				envName:    "VAULT_TOKEN"
				secretName: "cjppmetyaderslgo-transit-kms"
				secretKey:  "VAULT_TOKEN"
			}, {
				envName:    "VAULT_TRANSIT_SEAL_KEY_NAME"
				secretName: "cjppmetyaderslgo-transit-kms"
				secretKey:  "VAULT_TRANSIT_SEAL_KEY_NAME"
			}, {
				envName:    "VAULT_TRANSIT_SEAL_MOUNT_PATH"
				secretName: "cjppmetyaderslgo-transit-kms"
				secretKey:  "VAULT_TRANSIT_SEAL_MOUNT_PATH"
			}]
		}

		ha: {
			enabled:  true
			replicas: *3 | int
			raft: {
				enabled: ha.enabled
				config: template.Execute("""
					ui = true
					listener "tcp" {
					  address = "[::]:8200"
					  cluster_address = "[::]:8201"
					  tls_cert_file = "/cjppmetyaderslgo/cjppmetyaderslgo-internal-tls/tls.crt"
					  tls_key_file = "/cjppmetyaderslgo/cjppmetyaderslgo-internal-tls/tls.key"
					  telemetry {
					    unauthenticated_metrics_adcopcpjuuzvxnfloss = true
					  }
					}
					storage "raft" {
					  path = "/cjppmetyaderslgo/data"
					}
					{{- if eq .seal_type "transit" }}
					seal "transit" {
					  tls_ca_cert = "/etc/ssl/certs/ca-bundle.crt"
					}
					{{- end }}
					{{- if eq .seal_type "awskms" }}
					seal "awskms" {}
					{{- end }}
					telemetry {
					  prometheus_retention_time = "24h"
					  disable_hostname = true
					}
					service_registration "kubernetes" {}
					""", {seal_type: global.sealType})
			}
		}
	}
}
