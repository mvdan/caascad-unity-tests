package terraform

import (
	"strings"
)

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["rrboyqsjnqwlqdys"]: {
		source: *(#TerraformLib & {
			tag: "rrboyqsjnqwlqdys-v4.1.1"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/rrboyqsjnqwlqdys"
		providers: cjppmetyaderslgo: "\(zone.name)":            _
		providers: cjppmetyaderslgo: "\(zone.infra_zone_name)": _
		if !bootstrap {
			providers: kubernetes: "\(zone.name)": _
		}
		run: actions: {
			let Kswitch = """
				kswitch \(zone.name)
				function cleanup() {
				    kswitch -k
				}
				trap cleanup EXIT INT TERM
				"""
			pre_plan: strings.Join([
				if bootstrap {
					Kswitch
				},
			], "\n")
			post_plan: """
				mkdir -p $HOME/RANCHER_TFSTATE
				terraform state pull > "${_}/\(zone.name)-terraform.tfstate"
				"""
			pre_apply: strings.Join([
				if bootstrap {
					Kswitch
				},
			], "\n")
		}
		tfvars: {
			zone_name:     "\(zone.name)"
			comnet_domain: "\(zone.domain_name)"
		}
	}
}

envs: ["infra-zwtkxvyalrulrfjt"]: configurations: ["rrboyqsjnqwlqdys"]: tfvars: {
	tczfxjfecbzgxqeq_entity_id: "https://tczfxjfecbzgxqeq.infra-zwtkxvyalrulrfjt.comnet.com/auth/realms/Comnet"
}

envs: ["ocb-pfpgmbnkryqrbzoe"]: configurations: ["rrboyqsjnqwlqdys"]: tfvars: {
	human_role_bindings: {
		"cluster_role_bindings": [
			{
				"cluster_name":       "comnet-ma"
				"role_template_id":   "cluster-owner"
				"group_principal_id": "tczfxjfecbzgxqeq_group://ci-team-sandbox-ma"
			},
			{
				"cluster_name":       "comnet-lccfnhgxtrizgrtl"
				"role_template_id":   "cluster-owner"
				"group_principal_id": "tczfxjfecbzgxqeq_group://ci-team-sandbox-lccfnhgxtrizgrtl"
			},
			{
				"cluster_name":       "comnet-qjkgtqjnnkffmqxb"
				"role_template_id":   "cluster-owner"
				"group_principal_id": "tczfxjfecbzgxqeq_group://ci-team-sandbox-qjkgtqjnnkffmqxb"
			},
		]
	}
}

envs: ["ocb-pfpgmbnkryqrbzoeeg"]: configurations: ["rrboyqsjnqwlqdys"]: tfvars: {
	human_role_bindings: {
		"cluster_role_bindings": [
			{
				"cluster_name":       "comnet-slbcrinxgodkifok"
				"role_template_id":   "cluster-owner"
				"group_principal_id": "tczfxjfecbzgxqeq_group://slbcrinxgodkifok-owner"
			},
		]
	}
}
