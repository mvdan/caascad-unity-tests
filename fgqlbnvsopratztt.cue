package terraform

envs: [string]: {
	zone: _
	configurations: ["pnjicteepvblcvub"]: {
		source: *(#GitSource & {
			url:    "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/pnjicteepvblcvub"
			branch: "master"
		}) | #GitSource | #LocalSource
		providers: kubernetes: "\(zone.name)": _
		helm: {
			release_name: "pnjicteepvblcvub"
			path:         "./helm"
			namespace:    "comnet-pnjicteepvblcvub"
			if zone.type == "client" {
				values: {
					resources: {
						limits: {
							cpu:    "1"
							memory: "128Mi"
						}
						requests: {
							cpu:    "15m"
							memory: "15Mi"
						}
					}
				}
			}
		}
		run: actions: post_apply: """
			kubectl wait pod -n \(helm.namespace) -l app=pnjicteepvblcvub --for=condition=Ready --timeout 60s
			"""
	}
}
