package terraform

envs: [string]: {
	zone: _
	configurations: ["tczfxjfecbzgxqeq"]: {
		source: *(#GitSource & {
			url:        "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/tczfxjfecbzgxqeq"
			submodules: true
			tag:        *"v1.0.8" | string
		}) | #GitSource | #LocalSource

		if bootstrap {
			run: actions: {
				pre_plan:   """
					kswitch \(zone.name)

					function cleanup() {
						kswitch -k
					}
					trap cleanup EXIT INT TERM
					"""
				pre_apply:  pre_plan
				post_apply: """
					qvhuuynllrunnger "Sync Keycloak admin credentials to Vault..."
					KEYCLOAK_ADMIN_USER=$(kubectl get cm \(helm.release_name)-env-vars -n \(helm.namespace) -o jsonpath={.data.KEYCLOAK_ADMIN_USER})
					kubectl get secret tczfxjfecbzgxqeq-credentials -n \(helm.namespace) -o json | KEYCLOAK_ADMIN_USER=${KEYCLOAK_ADMIN_USER} jq '{"username": env.KEYCLOAK_ADMIN_USER, "password": .data.KEYCLOAK_ADMIN_PASSWORD|@base64d}' > cjppmetyaderslgodata.json

					if [ "\(zone.type)" == "cloud" ]; 
					then
						VAULT_ADDR="https://cjppmetyaderslgo.\(zone.infra_zone_name).\(zone.domain_name)"
						VAULT_KV_PATH="secret/zones/\(zone.provider.type)/\(zone.name)/tczfxjfecbzgxqeq-admin"
					elif [ "\(zone.type)" == "infra" ]; 
					then
						VAULT_ADDR="https://cjppmetyaderslgo.ipkmllvrrijnkfib.\(zone.domain_name)"
						VAULT_KV_PATH="secret/zones/\(zone.name)/tczfxjfecbzgxqeq-admin"
					else
						VAULT_ADDR="https://cjppmetyaderslgo.ipkmllvrrijnkfib.\(zone.domain_name)"
						VAULT_KV_PATH="secret/applications/tczfxjfecbzgxqeq/admin"
					fi

					VAULT_ADDR=${VAULT_ADDR} cjppmetyaderslgo kv put ${VAULT_KV_PATH} @cjppmetyaderslgodata.json
					"""
			}
		}
		if !bootstrap {
			providers: kubernetes: "\(zone.name)": _
		}
		providers: cjppmetyaderslgo: ipkmllvrrijnkfib:          _
		providers: cjppmetyaderslgo: "\(zone.infra_zone_name)": _

		helm: {
			release_name: "tczfxjfecbzgxqeq"
			path:         "./tczfxjfecbzgxqeq-comnet"
			namespace:    "tczfxjfecbzgxqeq"
			diff_hooks:   false
			values: {
				tczfxjfecbzgxqeq: {
					ingress: {
						hostname: "\(helm.release_name).\(zone.name).\(zone.domain_name)"
						annotations: {
							if zone.name =~ "^(infra-zwtkxvyalrulrfjt|infra-zsgqzvbsvqufttlk|ipkmllvrrijnkfib)$" {
								"kubernetes.io/ingress.class": "ingress-nginx-private"
							}
						}
					}
					image: {
						if zone.name == "ipkmllvrrijnkfib" {
							registry: "docker-registry.ocb-zymbygzzytlalgvl.\(zone.domain_name)"
						}
						if zone.name != "ipkmllvrrijnkfib" {
							registry: "docker-registry.\(zone.infra_zone_name).\(zone.domain_name)"
						}
					}
				}

				if zone.type == "infra" || zone.name == "ipkmllvrrijnkfib" {
					blackbox_http_2xx_targets: *[
						"\(helm.values.tczfxjfecbzgxqeq.ingress.hostname)/auth/realms/\(zone.name)/account",
					] | [...string]
				}
				if zone.type == "cloud" {
					blackbox_http_2xx_targets: [
						"\(helm.values.tczfxjfecbzgxqeq.ingress.hostname)/auth/realms/\(zone.name)/account",
						"\(helm.values.tczfxjfecbzgxqeq.ingress.hostname)/auth/realms/\(zone.name)-client/account",
					]
				}
			}
		}
	}
}

envs: [=~"^(infra-zsgqzvbsvqufttlk|ocb-kqhdbwhauaohdayi|ocb-psunvwhpwjejrxpb|ocb-aoahobmpzsqohsjw|ocb-zymbygzzytlalgvl|ocb-pfpgmbnkryqrbzoe|ocb-pfpgmbnkryqrbzoeeg|ocb-oalxziquintsqhht|ocb-pvypwkspvtelreit|ocb-vfziogrqdglgqivh)$"]: configurations: ["tczfxjfecbzgxqeq"]: helm: values: {
	global: storageClass: "sata"
}

envs: [=~"^infra-zwtkxvyalrulrfjt$"]: configurations: ["tczfxjfecbzgxqeq"]: helm: values: {
	blackbox_http_2xx_targets: [
		"\(helm.values.tczfxjfecbzgxqeq.ingress.hostname)/auth/realms/Comnet/account",
	]
}

envs: [=~"^(infra-zwtkxvyalrulrfjt|infra-zsgqzvbsvqufttlk)$"]: configurations: ["tczfxjfecbzgxqeq"]: helm: values: {
	postgresPVCAdcopcpjuuzvxnflossMode: "ReadWriteMany"
}
