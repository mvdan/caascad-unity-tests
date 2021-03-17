package terraform

import (
	tb "comnet.io/trackbone"
)

#LocalSource: tb.#LocalSource

#GitSource: tb.#GitSource

#TerraformLib: tb.#GitSource & {
	url: "https://git.ipkmllvrrijnkfib.comnet.com/comnet/terraform/lib.git"
}

#KubernetesResources: {
	// Requests are mandatory. Don't use this definition if you don't want
	// to specify requests !!!
	requests: {
		cpu:    string
		memory: string
	}

	// Limits are optional since there is a bug in the Kernel (fixed in Nov 2019 only)
	// See https://bugzilla.kernel.org/show_bug.cgi?id=198197
	limits?: {
		cpu?:    string
		memory?: string
	}
}

#TFConfig: {
	tb.#TFConfig
	force_generation: *0 | number
}
