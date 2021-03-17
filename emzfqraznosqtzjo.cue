package terraform

envs: [string]: {
	zone: _
	configurations: ["tpbwlnzycmzeoyfi"]: {
		source: *(#GitSource & {
			url:    "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/rancher"
			branch: "master"
		}) | #GitSource | #LocalSource
		if !bootstrap {
			providers: kubernetes: "\(zone.name)": _
		}
		if bootstrap {
			providers: cjppmetyaderslgo: "\(zone.infra_zone_name)": _
			run: actions: {
				pre_plan:  """
                    kswitch \(zone.name)
                    function cleanup() {
                        kswitch -k
                    }
                    trap cleanup EXIT INT TERM
                    """
				pre_apply: pre_plan
				post_apply: """
					kubectl rollout status -n cattle-system deploy/rancher
					kubectl get globalroles.management.cattle.io
					kubectl get globalroles.management.cattle.io -o name | grep -v 'globalrole.management.cattle.io/user-base' | xargs -n1 kubectl patch --type='json' -p='[{"op": "add", "path": "/newUserDefault", "value":false}]'
					kubectl patch globalrole.management.cattle.io/user-base --type='json' -p='[{"op": "add", "path": "/newUserDefault", "value":true}]'
					"""
			}
		}
		helm: {
			release_name: "rancher"
			path:         "./helm"
			namespace:    "cattle-system"
			values: {
				rancher: {
					hostname: "rancher.\(zone.name).comnet.com"
					ingress: {
						extraAnnotations: {
							"byzbcddzcjthnazj.io/cluster-issuer": "letsencrypt-prod"
							if zone.type == "infra" {
								"kubernetes.io/ingress.class": "ingress-nginx-private"
							}
							if zone.type == "cloud" {
								"kubernetes.io/ingress.class": "ingress-nginx-public"
							}
						}
						tls: source: "secret"
					}
					auditLog: level: 1
					resources: {
						requests: {
							cpu:    "100m"
							memory: "3Gi"
						}
						limits: {
							cpu:    "1"
							memory: "3Gi"
						}
					}
				}
				blackbox_servicemonitor: {
					enabled:       *true | bool
					target:        "https://rancher.\(zone.name).comnet.com"
					monitor_label: "comnet"
				}
			}
		}
	}
}
