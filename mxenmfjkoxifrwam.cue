package terraform

import (
	"strings"
)

envs: [string]: {
	zone: _
	configurations: ["rrboyqsjnqwlqdys-cloud"]: {
		source: *(#TerraformLib & {
			tag: "rrboyqsjnqwlqdys-v5.0.3"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/rrboyqsjnqwlqdys-cloud"
		providers: cjppmetyaderslgo: "\(zone.name)":            _
		providers: cjppmetyaderslgo: "\(zone.infra_zone_name)": _
		run: actions: {
			let Migration = """
				TFSTATE_PATH=${HOME}/RANCHER_TFSTATE
				terraform init
				terraform state list 2>&1 >/dev/null || {
					cp ${TFSTATE_PATH}/\(zone.name)-terraform.tfstate terraform.tfstate
					terraform init -reconfigure -force-copy
					sleep 10

					# clusters are owned by clients
					test -n "$(terraform state list | grep module.rrboyqsjnqwlqdys_config.rrboyqsjnqwlqdys_cluster.clusters)" && terraform state rm module.rrboyqsjnqwlqdys_config.rrboyqsjnqwlqdys_cluster.clusters
				}
				"""
			pre_plan: strings.Join([
					Migration,
			], "\n")
		}
		tfvars: #Rancher2CloudTFvars & {
			zone_name:       "\(zone.name)"
			infra_zone_name: "\(zone.infra_zone_name)"
			comnet_domain:  "\(zone.domain_name)"
		}
	}
}

#Rancher2CloudTFvars: {
	infra_zone_name:           string
	tczfxjfecbzgxqeq_entity_id:        *null | string
	tczfxjfecbzgxqeq_x509_certificate: *null | string
	tczfxjfecbzgxqeq_key_name:         *null | string
	#Rancher2BaseTFvars
}
