package terraform

import (
	tb "comnet.io/trackbone"
)

envs: [string]: {
	zone: _
	configurations: ["iyphjdnvrvpkizcu"]: {
		source: *(tb.#GitSource & {
			url:        "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/iyphjdnvrvpkizcu.git"
			submodules: true
			tag:        *"v0.9.1" | string
		}) | tb.#GitSource | #LocalSource
		providers: kubernetes: "\(zone.name)": _
		helm: {
			release_name: "iyphjdnvrvpkizcu"
			path:         "./comnet-iyphjdnvrvpkizcu-chart"
			namespace:    "iyphjdnvrvpkizcu"
			values: {
				route: enabled:                      false
				iyphjdnvrvpkizcuBackup: enabled:     false
				iyphjdnvrvpkizcuProxyRoute: enabled: false
				iyphjdnvrvpkizcuProxy: {
					enabled: true
					env: {
						iyphjdnvrvpkizcuHttpHost: "iyphjdnvrvpkizcu.\(zone.name).\(zone.domain_name)"
						enforceHttps:             true
					}
				}
				service: {
					name:    "iyphjdnvrvpkizcu-service"
					enabled: true
				}
				persistence: {
					enabled:      true
					storageClass: "comnet-storage-standard"
					storageSize:  "30Gi"
				}
				config: enabled: false
			}
		}
	}
}
