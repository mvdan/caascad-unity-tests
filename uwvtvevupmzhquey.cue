package terraform

envs: [string]: {
	zone: _
	configurations: ["nkpqmhmopbjlhrgs"]: {
		source: *(#GitSource & {
			url:    "https://git.ipkmllvrrijnkfib.comnet.com/comnet/helm/metrics-server"
			branch: "master"
		}) | #GitSource | #LocalSource
		providers: kubernetes: "\(zone.name)": _
		helm: {
			release_name: "metrics-server"
			path:         "./helm"
			namespace:    "comnet-system"
			if zone.type == "client" {
				values: {
					resources: {
						limits: {
							cpu:    "1"
							memory: "128Mi"
						}
						requests: {
							cpu:    "10m"
							memory: "15Mi"
						}
					}
				}
			}
		}
	}
}

envs: ["mjgymrtsrufltfdo"]: configurations: ["nkpqmhmopbjlhrgs"]: helm: values: {
	#MetricsServerHAHelmValues
}

envs: ["ocb-ilpybubiybhtluxw"]: configurations: ["nkpqmhmopbjlhrgs"]: helm: values: {
	#MetricsServerHAHelmValues
}

#MetricsServerHAHelmValues: {
	podDisruptionBudget: enabled: true
	replicas: 2
	affinity: podAntiAffinity: preferredDuringSchedulingIgnoredDuringExecution: [{
		podAffinityTerm: {
			labelSelector: {
				matchExpressions: [
					{
						key:      "app.kubernetes.io/name"
						operator: "In"
						values: ["metrics-server"]
					},
					{
						key:      "app.kubernetes.io/instance"
						operator: "In"
						values: ["metrics-server"]
					},
				]
			}
			topologyKey: "failure-domain.beta.kubernetes.io/zone"
		}
		weight: 100
	}]
	...
}
