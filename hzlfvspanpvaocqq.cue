package terraform

envs: [string]: {
	zone: _
	configurations: ["wpkeypipxxjfjnsg"]: {
		source: *(#GitSource & {
			url: "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/wpkeypipxxjfjnsg"
			tag: *"v1.0.0" | string
		}) | #GitSource | #LocalSource
		providers: kubernetes: "\(zone.name)": _
		helm: {
			release_name: "wpkeypipxxjfjnsg"
			path:         "./helm"
			namespace:    "wpkeypipxxjfjnsg"
			extra_args: ["--post-renderer", "./renderer"]
			values: "wpkeypipxxjfjnsg": {
				hostname: "wpkeypipxxjfjnsg.\(zone.name).comnet.com"
				realm:    *zone.name | string
				if zone.name == "infra-zwtkxvyalrulrfjt" {
					realm: "Comnet"
				}
				config: {
					clientID:     "wpkeypipxxjfjnsg"
					cookieSecret: "0AKgG9JSxe1amE39PzW1JugCyjtrFOvazwD5sUOMQqs="
				}
				extraArgs: {
					"provider":                             "oidc"
					"provider-display-name":                "Keycloak"
					"footer":                               "-"
					"oidc-issuer-url":                      "https://tczfxjfecbzgxqeq.\(zone.name).\(zone.domain_name)/auth/realms/\(realm)"
					"insecure-oidc-allow-unverified-email": true
					"cookie-domain":                        ".\(zone.name).\(zone.domain_name)"
					"whitelist-domain":                     ".\(zone.name).\(zone.domain_name)"
					"set-xauthrequest":                     true
					"exclude-logging-paths":                "/ping"
					"cookie-expire":                        "12h"
				}
				podAnnotations: {
					"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject":                     "true"
					"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/role":                             "wpkeypipxxjfjnsg"
					"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/tls-skip-verify":                  "true"
					"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-pre-populate-only":          "true"
					"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-secret-wpkeypipxxjfjnsg": "secret/oidc/wpkeypipxxjfjnsg"
					"cjppmetyaderslgo.hashiipkmllvrrijnkfib.com/agent-inject-template-wpkeypipxxjfjnsg": """
						{{- with secret \"secret/oidc/wpkeypipxxjfjnsg\" -}}
						OAUTH2_PROXY_CLIENT_SECRET=\"{{ .Data.secret }}\"
						export OAUTH2_PROXY_CLIENT_SECRET
						{{- end }}
						"""
				}
				resources: {
					requests: {
						cpu:    "50m"
						memory: "1Gi"
					}
					limits: {
						cpu:    "50m"
						memory: "1Gi"
					}
				}
				serviceAccount: {
					enabled: "true"
					name:    "wpkeypipxxjfjnsg"
				}
				ingress: {
					enabled: "true"
					annotations: {
						if zone.type == "infra" {
							"kubernetes.io/ingress.class": "ingress-nginx-private"
						}
						if zone.type == "cloud" {
							"kubernetes.io/ingress.class": "ingress-nginx-public"
						}
						"byzbcddzcjthnazj.io/cluster-issuer": "letsencrypt-prod"
					}
					hosts: [hostname]
					tls: [{
						hosts: [hostname]
						secretName: "wpkeypipxxjfjnsg-tls"
					}]
				}
			}
		}
	}
}
