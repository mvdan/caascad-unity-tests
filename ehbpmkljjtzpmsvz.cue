package terraform

import (
	"strings"
)

envs: [string]: {
	zone: _
	configurations: ["mougprigxfirxlad"]: {
		source: *(#TerraformLib & {
			tag: "rrboyqsjnqwlqdys-v5.0.2"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/mougprigxfirxlad"
		providers: cjppmetyaderslgo: "\(zone.name)": _
		run: actions: {
			let Migration = """
				TFSTATE_PATH=${HOME}/RANCHER_TFSTATE
				terraform init
				terraform state list 2>&1 >/dev/null || {
					cp ${TFSTATE_PATH}/\(zone.name)-terraform.tfstate terraform.tfstate
					terraform init -reconfigure -force-copy
					sleep 10
				}
				"""
			pre_plan: strings.Join([
				Migration,
			], "\n")
		}
		tfvars: #Rancher2InfraTFvars & {
			zone_name:     "\(zone.name)"
			comnet_domain: "\(zone.domain_name)"
		}
	}
}

#Rancher2InfraTFvars: {
	tczfxjfecbzgxqeq_entity_id:        *null | string
	tczfxjfecbzgxqeq_x509_certificate: *null | string
	tczfxjfecbzgxqeq_key_name:         *null | string
	#Rancher2BaseTFvars
}

envs: ["infra-zwtkxvyalrulrfjt"]: configurations: ["mougprigxfirxlad"]: tfvars: {
	tczfxjfecbzgxqeq_entity_id: "https://tczfxjfecbzgxqeq.infra-zwtkxvyalrulrfjt.comnet.com/auth/realms/Comnet"
}
