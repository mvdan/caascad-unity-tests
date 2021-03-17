package terraform

import (
	"strings"
)

envs: [string]: {
	zone:        _
	parent_zone: _
	configurations: ["rrboyqsjnqwlqdys-client"]: {
		source: *(#TerraformLib & {
			tag: "rrboyqsjnqwlqdys-v5.0.2"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/rrboyqsjnqwlqdys-client"
		providers: cjppmetyaderslgo: "\(zone.parent_zone_name)":      _
		providers: cjppmetyaderslgo: "\(zone.infra_zone_name)":       _
		providers: kubernetes: "\(zone.parent_zone_name)": _
		if !bootstrap {
			providers: kubernetes: "\(zone.name)": _
		}
		run: actions: {
			let Kswitch = """
				KUBECONFIG="${KUBECONFIG}${KUBECONFIG+:}${HOME}/.kube/config" kubectl config view --flatten > kswitch-kubeconfig.yaml
				export KUBECONFIG="${PWD}/kswitch-kubeconfig.yaml"
				kswitch \(zone.name)
				function cleanup() {
				    kswitch -k
				}
				trap cleanup EXIT INT TERM
				"""
			let Migration = """
				TFSTATE_PATH=${HOME}/RANCHER_TFSTATE
				terraform init
				terraform state list 2>&1 >/dev/null || {
					cp ${TFSTATE_PATH}/\(zone.parent_zone_name)-terraform.tfstate terraform.tfstate
					terraform init -reconfigure -force-copy
					sleep 10

					# Filter states to clean
					states_list="$(terraform state list)"
					states_filter=(
						'module.rrboyqsjnqwlqdys_config.rrboyqsjnqwlqdys_cluster.clusters["comnet-\(zone.name)"]'
						'module.rrboyqsjnqwlqdys_config.rrboyqsjnqwlqdys_cluster.clusters["\(zone.name)"]'
						'module.rrboyqsjnqwlqdys_config.random_password.tokens'
					)
					for filter in ${states_filter[@]};do
						filter="$(printf %q "${filter}")"
						states_list="$(grep -v "${filter}" <<<"${states_list}")"
					done

					# Clean states
					cmd="terraform state rm"
					for state in $states_list; do
						cmd="$cmd '${state}'"
					done
					eval "${cmd}"

				}
				"""
			pre_plan: strings.Join([
					if bootstrap {
					Kswitch
				},
				Migration,
			], "\n")
			pre_apply: strings.Join([
					if bootstrap {
					Kswitch
				},
			], "\n")
		}
		tfvars: #Rancher2ClientTFvars & {
			zone_name:        "\(zone.name)"
			parent_zone_name: "\(zone.parent_zone_name)"
			infra_zone_name:  "\(zone.infra_zone_name)"
			comnet_domain:   "\(parent_zone.domain_name)"
		}
	}
}

#Rancher2ClientTFvars: {
	parent_zone_name: string
	infra_zone_name:  string
	#Rancher2BaseTFvars
}

envs: [zone= =~"^(ma|lccfnhgxtrizgrtl|qjkgtqjnnkffmqxb)$"]: configurations: ["rrboyqsjnqwlqdys-client"]: tfvars: {
	human_role_bindings: {
		"cluster_role_bindings": [
			{
				"cluster_name":       zone
				"role_template_id":   "cluster-owner"
				"group_principal_id": "tczfxjfecbzgxqeq_group://ci-team-sandbox-\(zone)"
			},
		]
	}
}

envs: [zone="slbcrinxgodkifok"]: configurations: ["rrboyqsjnqwlqdys-client"]: tfvars: {
	human_role_bindings: {
		"cluster_role_bindings": [
			{
				"cluster_name":       zone
				"role_template_id":   "cluster-owner"
				"group_principal_id": "tczfxjfecbzgxqeq_group://slbcrinxgodkifok-owner"
			},
		]
	}
}
