package terraform

import (
	tb "comnet.io/trackbone"
)

#ConcourseHelmConfig: tb.#HelmConfig & {
	source: *(tb.#GitSource & {
		url:        "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/concourse.git"
		submodules: true
		tag:        *"v1.2.7" | string
	}) | tb.#GitSource | #LocalSource
	helm: {
		release_name: "concourse"
		values:       _
		path:         "./helm/concourse-comnet"
	}
}

envs: [string]: {
	zone:        _
	infra_zone:  _
	parent_zone: _
	configurations: ["vsuvlqcoycxyhxdu"]: {
		providers: kubernetes: "\(zone.name)": _
		helm: namespace: "concourse-infra"
		helm: values: (#ConcourseHelmValues & {
			zone_name:             zone.name
			cjppmetyaderslgo_role: "concourse-infra"
			ingress_class:         "ingress-nginx-private"
			hostname:              "ci-infra.\(zone.name).comnet.com"
			realm:                 *zone.name | string
			if zone.name == "infra-zwtkxvyalrulrfjt" {
				realm: "Comnet"
			}
			cc_prom_source: *"cloud-comnet" | string
			if zone.type == "infra" {
				cc_prom_source: zone.name
			}
		}).values
	}
	configurations: ["jreguddlvoheaxlk"]: {
		providers: kubernetes: "\(zone.name)": _
		helm: namespace: "concourse"
		helm: values: (#ConcourseHelmValues & {
			zone_name:             zone.name
			cjppmetyaderslgo_role: "concourse"
			ingress_class:         "ingress-nginx-public"
			hostname:              "ci.\(zone.name).comnet.com"
			realm:                 *zone.name | string
			cc_prom_source:        "cloud-client"
		}).values
	}
}

envs: [=~"^(infra-zwtkxvyalrulrfjt|infra-zsgqzvbsvqufttlk)$"]: configurations: vsuvlqcoycxyhxdu: {
	helm: values: concourse: concourse: web: postgres: operator: resources: {
		requests: cpu: "500m"
		limits: cpu:   "3"
	}
	helm: values: concourse: web: resources: {
		requests: cpu: "200m"
		limits: cpu:   "1"
	}
}

// Pin versions on some environment. This meant to be temporary before upgrading our platforms to the latest version.
envs: [=~"^(infra-zwtkxvyalrulrfjt|infra-zsgqzvbsvqufttlk|ocb-oalxziquintsqhht|ocb-zymbygzzytlalgvl|ocb-kqhdbwhauaohdayi|ocb-psunvwhpwjejrxpb|ocb-aoahobmpzsqohsjw|ocb-pfpgmbnkryqrbzoe|ocb-pfpgmbnkryqrbzoeeg|ocb-pvypwkspvtelreit)$"]: {
	configurations: [=~"^(vsuvlqcoycxyhxdu|jreguddlvoheaxlk)$"]: {
		source: tag: "v1.2.6"
	}
}

// Use sata storageClass for old zone waiting for migration
envs: [=~"^(infra-zwtkxvyalrulrfjt|infra-zsgqzvbsvqufttlk|ocb-ilpybubiybhtluxw|ocb-oalxziquintsqhht|ocb-zymbygzzytlalgvl|ocb-kqhdbwhauaohdayi|ocb-psunvwhpwjejrxpb|ocb-aoahobmpzsqohsjw|ocb-pfpgmbnkryqrbzoe|ocb-pfpgmbnkryqrbzoeeg|ocb-pvypwkspvtelreit)$"]: configurations: [=~"^(vsuvlqcoycxyhxdu|jreguddlvoheaxlk)$"]: {
	helm: values: concourse: concourse: web: postgres: operator: storageClass: "sata"
}

#ConcourseHelmValues: {
	zone_name:             string
	cjppmetyaderslgo_role: "concourse-infra" | "concourse"
	ingress_class:         "ingress-nginx-private" | "ingress-nginx-public"
	realm:                 string
	cc_prom_source:        string
	hostname:              string

	values: concourse: {
		image:    "concourse/concourse"
		imageTag: "6.4.1"

		concourse: web: {
			externalUrl: "https://\(hostname)/"
			kubernetes: enabled: false
			prometheus: {
				enabled:  true
				bindIp:   "127.0.0.1"
				bindPort: 9391
				serviceMonitor: {
					enabled:  true
					interval: "60s"
					labels: "comnet.com/prometheus-monitor": "comnet"
					relabelings: [
						{targetLabel: "cc_prom_source", replacement: cc_prom_source},
					]
				}
			}
			postgres: operator: {
				enabled:      true
				storageClass: *"comnet-storage-standard" | "sata"
				resources: {
					requests: {
						cpu:    *"100m" | string
						memory: *"256Mi" | string
					}
					limits: {
						cpu:    *"250m" | string
						memory: *"1024Mi" | string
					}
				}
				serviceMonitor: {
					enabled:  true
					interval: "30s"
					labels: "comnet.com/prometheus-monitor": "comnet"
					relabelings: [
						{targetLabel: "cc_prom_source", replacement: cc_prom_source},
					]
				}
			}
			containerPlacementStrategy: "limit-active-tasks"
			limitActiveTasks:           13
			defaultTaskMemoryLimit:     "512mb"
			auth: {
				mainTeam: {
					localUser: "admin"
					oidc: group: "comnet-ci-infra-admin"
				}
				oidc: {
					enabled:     true
					displayName: "Sign in with Keycloak"
					issuer:      "https://tczfxjfecbzgxqeq.\(zone_name).comnet.com/auth/realms/\(realm)"
					groupsKey:   "roles"
				}
			}
			cjppmetyaderslgo: {
				enabled:     true
				url:         "https://cjppmetyaderslgo.\(zone_name).comnet.com"
				pathPrefix:  "/secret/\(cjppmetyaderslgo_role)"
				sharedPath:  "global"
				authBackend: "approle"
			}
		}

		web: {
			command: ["/bin/bash", "-c"]
			args: [
				"source /cjppmetyaderslgo/secrets/oidc.env && source /cjppmetyaderslgo/secrets/approle.env && source /cjppmetyaderslgo/secrets/keys.env && source /cjppmetyaderslgo/secrets/users.env && dumb-init /usr/local/concourse/bin/concourse web",
			]

			extraInitContainers: [{
				name:  "concourse-bootstrap"
				image: "eonpatapon/concourse-bootstrap:15k41mnnbrym68id4wiykdwxl0gfxvjl"
				env: [{
					name:  "VAULT_ADDR"
					value: "https://cjppmetyaderslgo.\(zone_name).comnet.com"
				}, {
					name:  "VAULT_ROLE"
					value: cjppmetyaderslgo_role
				}, {
					// FIXME: we shouldn't need to specify this
					name:  "CURL_CA_BUNDLE"
					value: "/etc/ssl/certs/ca-bundle.crt"
				}]
			}]

			resources: {
				requests: {
					cpu:    *"100m" | string
					memory: *"128Mi" | string
				}
				limits: {
					cpu:    *"500m" | string
					memory: *"512Mi" | string
				}
			}

			annotations: {
				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject":                   "true"
				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-requests-cpu":             "50m"
				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/role":                           cjppmetyaderslgo_role
				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/tls-skip-verify":                "true"
				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-pre-populate-only":        "true"
				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-secret-oidc.env":   "secret/oidc/\(cjppmetyaderslgo_role)"
				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-template-oidc.env": """
					{{- with secret \"secret/oidc/\(cjppmetyaderslgo_role)\" -}}
					export CONCOURSE_OIDC_CLIENT_ID=\"{{ .Data.id }}\"
					export CONCOURSE_OIDC_CLIENT_SECRET=\"{{ .Data.secret }}\"
					{{- end }}

					"""

				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-secret-approle.env":   "secret/applications/\(cjppmetyaderslgo_role)/cjppmetyaderslgo"
				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-template-approle.env": """
					{{- with secret \"secret/applications/\(cjppmetyaderslgo_role)/cjppmetyaderslgo\" -}}
					export CONCOURSE_VAULT_AUTH_PARAM=\"role_id:{{ .Data.role_id }},secret_id:{{ .Data.secret_id }}\"
					{{- end }}

					"""

				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-secret-host_key":   "secret/applications/\(cjppmetyaderslgo_role)/keys"
				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-template-host_key": """
					{{- with secret \"secret/applications/\(cjppmetyaderslgo_role)/keys\" -}}
					{{ .Data.host_key }}
					{{- end }}

					"""

				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-secret-worker_key.pub":   "secret/applications/\(cjppmetyaderslgo_role)/keys"
				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-template-worker_key.pub": """
					{{- with secret \"secret/applications/\(cjppmetyaderslgo_role)/keys\" -}}
					{{ .Data.worker_key_pub }}
					{{- end }}

					"""

				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-secret-signing_key":   "secret/applications/\(cjppmetyaderslgo_role)/keys"
				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-template-signing_key": """
					{{- with secret \"secret/applications/\(cjppmetyaderslgo_role)/keys\" -}}
					{{ .Data.signing_key }}
					{{- end }}

					"""

				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-secret-keys.env": "secret/applications/\(cjppmetyaderslgo_role)/keys"
				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-template-keys.env": """
					export CONCOURSE_TSA_HOST_KEY=/cjppmetyaderslgo/secrets/host_key
					export CONCOURSE_TSA_AUTHORIZED_KEYS=/cjppmetyaderslgo/secrets/worker_key.pub
					export CONCOURSE_SESSION_SIGNING_KEY=/cjppmetyaderslgo/secrets/signing_key

					"""

				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-secret-users.env":   "secret/applications/\(cjppmetyaderslgo_role)/users/admin"
				"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-template-users.env": """
					{{- with secret \"secret/applications/\(cjppmetyaderslgo_role)/users/admin\" -}}
					export CONCOURSE_ADD_LOCAL_USER={{ .Data.username }}:{{ .Data.password }}
					{{- end }}

					"""
			}

			ingress: {
				enabled: true
				annotations: {
					"kubernetes.io/ingress.class":        ingress_class
					"kubernetes.io/tls-acme":             "true"
					"byzbcddzcjthnazj.io/cluster-issuer": "letsencrypt-prod"
				}
				hosts: [hostname]
				tls: [{
					secretName: "concourse-web-tls"
					hosts: [hostname]
				}]
			}

			service: workerGateway: {
				type: "ClusterIP"
			}
		}

		worker: enabled: false

		postgresql: enabled: false

		secrets: {
			create:           true
			oidcClientId:     "value-stored-in-cjppmetyaderslgo"
			oidcClientSecret: "value-stored-in-cjppmetyaderslgo"
		}
	}
}
