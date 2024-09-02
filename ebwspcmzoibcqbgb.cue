package terraform

import (
	"strings"
	"time"
)

envs: [string]: {
	zone: _
	configurations: ["csbhovxlbadjlhuw"]: {
		source: *(#GitSource & {
			url:        "https://git.ipkmllvrrijnkfib.comnet.com/comnet/applications/csbhovxlbadjlhuw"
			submodules: true // This is used to remove previous kustomize objects
			tag:        *"v1.0.5" | string
		}) | #GitSource | #LocalSource
		if !bootstrap {
			providers: kubernetes: "\(zone.name)": _
		}
		if bootstrap {
			providers: cjppmetyaderslgo: "\(zone.infra_zone_name)": _
		}
		run: actions: {
			let Kswitch = """
				kswitch \(zone.name)
				function cleanup() {
					kswitch -k
				}
				trap cleanup EXIT INT TERM
				"""
			if bootstrap {
				pre_plan: Kswitch
			}
			pre_apply: strings.Join([
				if bootstrap {
					Kswitch
				},
				"""
				kubectl create namespace \(helm.namespace) 2>/dev/null || true
				kubectl label namespace \(helm.namespace) --overwrite "openpolicyagent.org/webhook=ignore"
				""",
			], "\n")
		}
		helm: {
			release_name: "csbhovxlbadjlhuw"
			path:         "./helm/comnet-csbhovxlbadjlhuw"
			namespace:    "csbhovxlbadjlhuw"
			values: #OPAHelmValues & {}
		}
	}
}

#OPAHelmValues: {
	csbhovxlbadjlhuw?: {
		csbhovxlbadjlhuw?: {...}
		mgmt?: {
			enabled:          *true | bool
			image?:           string
			imageTag?:        string
			imagePullPolicy?: "IfNotPresent" | "Always" | "Never"
			port?:            int & >0 & <65536
			extraArgs?: [...string]
			resources?: {...}
			data?: {
				enabled: *true | bool
			}
			configmapPolicies?: {
				enabled: *true | bool
				namespaces?: [...string]
				requireLabel?: bool
			}
			replicate?: {
				cluster?: [...string]
				namespace?: [...string]
				path?: string
			}
		}
		bootstrapPolicies?: {...}
		annotations?: [string]: string
		certManager?: {
			enabled: *true | bool
		}
		prometheus?: {
			enabled: *true | bool
		}
		serviceMonitor?: {
			enabled:   *true | bool
			interval?: time.Duration
			additionalLabels?: [string]: string
			namespace?: string
		}
		admissionControllerKind?: [...{"ValidatingWebhookConfiguration" | "MutatingWebhookConfiguration"}]
		admissionControllerFailurePolicy?: "Ignore" | "Fail"
		admissionControllerNamespaceSelector?: {...}
		admissionControllerSideEffect?: "Unknown" | "None"
		admissionControllerRules?: [...]
		podDisruptionBudget?: {
			enabled:         *true | bool
			minAvailable?:   int
			maxUnavailable?: int
		}
		generateAdmissionControllerCerts?: bool
		admissionControllerCA?:            string
		admissionControllerCert?:          string
		admissionControllerKey?:           string
		authz?: {
			enabled?: *true | bool
		}
		hostNetwork?: {
			enabled: *true | bool
		}
		image?:           string
		imageTag?:        string
		imagePullPolicy?: "IfNotPresent" | "Always" | "Never"
		imagePullSecrets?: [...string]
		port?: int & >0 & <65536
		extraArgs?: [...string]
		logLevel?:  "debug" | "info" | "error"
		logFormat?: "json" | "text" | "json-pretty"
		replicas?:  int
		affinity?: {...}
		tolerations?: [...]
		nodeSelector?: {...}
		resources?: {...}
		rbac?: {
			create: *true | bool
			rules?: {
				cluster?: [...]
			}
		}
		serviceAccount?: {
			create: *true | bool
			name?:  string
		}
		priorityClass?: {
			enabled: *true | bool
			create?: bool
			value?:  int
			name?:   string
		}
		readinessProbe?: {...}
		livenessProbe?: {...}
		securityContext?: {
			enabled: *true | bool
			...
		}
		deploymentStrategy?: {...}
		extraContainers?: [...]
		extraVolumes?: [...]
		extraPorts?: [...]
	}
}
