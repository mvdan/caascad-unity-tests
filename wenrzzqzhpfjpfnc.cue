package terraform

import (
	"encoding/base64"
)

#CCETaint: {
	key:    string
	value:  string
	effect: "NoSchedule" | "PreferNoSchedule" | "NoExecute"
}

#CCENodePool: {
	os: "EulerOS 2.5"
	// Flavors
	// * s3.2xlarge.4: 8 CPU / 32G RAM
	// * s3.2xlarge.2: 8 CPU / 16G RAM
	// * s3.xlarge.2:  4 CPU / 8G RAM
	// * s3.xlarge.4:  4 CPU / 16G RAM
	// * s3.large.4:   2 CPU / 8G RAM
	// * m2.large.8:   2 CPU / 16G RAM
	flavor_id: "s3.2xlarge.4" | "s3.2xlarge.2" | "s3.xlarge.2" | "s3.xlarge.4" | "s3.large.4" | "m2.large.8"
	// When null nodes will be scheduled randomly on different AZs
	availability_zone: *null | "eu-west-0a" | "eu-west-0b" | "eu-west-0c"
	// Number of nodes to create in the node pool
	desired_nodes: int
	// For auto-scaling
	scall_enable:     true
	min_nodes:        *0 | number
	max_nodes:        *0 | number
	root_volume_size: 40
	data_volume_size: 100
	preinstall:       *"" | string
	postinstall:      *"" | string
	labels: [string]: string
	taints: [...#CCETaint]
}

#CCEQuayPool: #CCENodePool & {
	flavor_id:         *"m2.large.8" | "s3.large.4"
	availability_zone: "eu-west-0a"
	desired_nodes:     *1 | int
	labels: {
		comnet_node_reserved_app: "quay"
	}
	taints: [
		{
			key:    "comnet_node_reserved_app"
			value:  "quay"
			effect: "NoSchedule"
		},
		{
			key:    "comnet_node_reserved_app"
			value:  "quay"
			effect: "NoExecute"
		},
	]
}

envs: [string]: {
	zone: _
	configurations: ["dcopcpjuuzvxnflo"]: {
		source: *(#TerraformLib & {
			tag: "dcopcpjuuzvxnflo-v4.1.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/dcopcpjuuzvxnflo"
		providers: cjppmetyaderslgo: "\(zone.infra_zone_name)": _
		tfvars: {
			zone_name:       zone.name
			domain_name:     zone.domain_name
			infra_zone_name: zone.infra_zone_name

			private_zone:    *"\(zone.name).\(zone.priv_domain_name)" | string
			key_pair:        *configurations.ekcfqfyldqagosjs.tfvars.keypair_name | string
			vpc_subnet_name: *configurations.ekcfqfyldqagosjs.tfvars.subnet_name | string

			route53_secret_backend_name: *"aws" | string
			if zone.infra_zone_name == "infra-zwtkxvyalrulrfjt" {
				route53_secret_backend_name: "aws-prod"
			}

			cluster_name:    *"comnet-\(zone.name)" | string
			cluster_flavor:  *"dcopcpjuuzvxnflo.s2.small" | "dcopcpjuuzvxnflo.s2.medium" | "dcopcpjuuzvxnflo.s1.small"
			cluster_version: *"v1.17.9-r0" | "v1.15.11-r1" | "v1.15.6-r1" | "v1.13.10-r0"

			if ( zone.type == "client" ) {
				node_defaults_override: node_flavor: *"s3.xlarge.2" | string
			}
			if ( zone.type == "cloud" || zone.type == "infra" ) {
				node_defaults_override: node_flavor: *"s3.xlarge.4" | string
			}

			node_defaults_override: node_image_name: "CentOS 7.5" | *"CentOS 7.6" | "CentOS 7.7" | "EulerOS 2.5"

			dcopcpjuuzvxnflo_nodes: [string]: node_availability_zone: *"eu-west-0a" | "eu-west-0b" | "eu-west-0c"

			dcopcpjuuzvxnflo_node_pools: [=~"^[a-z0-9-]+$"]: #CCENodePool

			if (zone.type == "cloud" || zone.type == "infra") {
				// Quay pool for cloud and infra zones
				dcopcpjuuzvxnflo_node_pools: "quay-nodes": #CCEQuayPool
			}
		}
	}
}

envs: ["infra-zwtkxvyalrulrfjt"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_flavor:  "dcopcpjuuzvxnflo.s1.small"
	cluster_version: "v1.13.10-r0"

	node_defaults_override: node_flavor: "s3.2xlarge.2"
	dcopcpjuuzvxnflo_nodes: {
		"node-4": {}
		"node-5": {}
		"node-6": {}
		"node-7": {}
	}
	dcopcpjuuzvxnflo_node_pools: "quay-nodes": desired_nodes: 2
}

envs: ["infra-zsgqzvbsvqufttlk"]: configurations: dcopcpjuuzvxnflo: {
	tfvars: {
		cluster_version: "v1.13.10-r0"

		node_defaults_override: node_flavor: "s3.xlarge.4"
		dcopcpjuuzvxnflo_nodes: {
			"node-0": {}
			"node-1": {}
			"node-2": {}
			"node-3": {}
		}
	}
}

envs: ["ocb-ilpybubiybhtluxw"]: configurations: dcopcpjuuzvxnflo: {
	tfvars: {
		cluster_version: "v1.13.10-r0"
		dcopcpjuuzvxnflo_nodes: {
			"node-2": {}
			"node-4": {}
			"node-5": {}
			"node-6": {}
			"node-7": {}
			"node-8": {}
			"node-9": {}
		}
		dcopcpjuuzvxnflo_node_pools: "quay-nodes": desired_nodes: 2
	}
}

envs: ["ocb-lwwscgigvcjwzflo"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	node_defaults_override: {
		node_flavor:     "s3.2xlarge.4"
		node_image_name: "CentOS 7.7"
	}
	dcopcpjuuzvxnflo_nodes: {
		"node-0": {}
		"node-1": {}
		"node-2": {}
		"node-3": {}
	}
}

envs: ["ocb-qpdtojgiovptnsqa"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	node_defaults_override: {
		node_flavor:     "s3.2xlarge.4"
		node_image_name: "CentOS 7.7"
	}
	dcopcpjuuzvxnflo_nodes: {
		"node-0": {}
		"node-1": {}
		"node-2": {}
		"node-3": {}
	}
}

envs: ["ocb-brxvogdhrnvxazrp"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_version: "v1.15.11-r1"

	node_defaults_override: {
		node_flavor:     "s3.2xlarge.4"
		node_image_name: "EulerOS 2.5"
	}
	dcopcpjuuzvxnflo_nodes: {
		"node-0": {}
		"node-1": {}
		"node-2": {}
		"node-3": {}
	}
}

envs: ["ocb-oalxziquintsqhht"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_version: "v1.13.10-r0"

	dcopcpjuuzvxnflo_nodes: {
		"node-0": {}
		"node-1": {}
		"node-2": {}
		"node-3": {}
		"node-4": {
			node_flavor: "s3.2xlarge.4"
		}
		"node-5": {
			node_flavor: "s3.2xlarge.4"
		}
		"node-6": {
			node_flavor: "s3.2xlarge.4"
		}
		"node-7": {
			node_flavor: "s3.2xlarge.4"
		}
	}
}

envs: ["eerryhrhvgbduosx"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_version: "v1.17.9-r0"
	dcopcpjuuzvxnflo_node_pools: {
		"worker-nodes": {
			flavor_id:         "s3.xlarge.2"
			availability_zone: "eu-west-0a"
			desired_nodes:     2
		}
	}
}

envs: ["unepmqybzvtwmyjx"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_version: "v1.15.6-r1"

	node_defaults_override: node_image_name: "CentOS 7.5"
	dcopcpjuuzvxnflo_nodes: {
		"node-1": {}
		"node-2": {}
	}
}

envs: ["hszqlstppgwrbexx"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_version: "v1.15.6-r1"

	node_defaults_override: node_image_name: "CentOS 7.5"
	dcopcpjuuzvxnflo_nodes: {
		"node-1": {}
		"node-2": node_availability_zone: "eu-west-0b"
	}
}

envs: ["ttvvzubrxywbjxob"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	node_defaults_override: {
		node_flavor:     "s3.xlarge.2"
		node_image_name: "CentOS 7.7"
	}
	dcopcpjuuzvxnflo_nodes: {
		"node-1": node_availability_zone: "eu-west-0a"
		"node-2": node_availability_zone: "eu-west-0b"
	}
}

envs: ["xladugdwqeqdipbl"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_version: "v1.15.6-r1"

	node_defaults_override: node_image_name: "CentOS 7.5"
	dcopcpjuuzvxnflo_nodes: {
		"test-node-0": {
			node_name: "test-node-0"
		}
		"test-node-1": {
			node_name:              "test-node-1"
			node_availability_zone: "eu-west-0b"
		}
	}
}

envs: ["gnjpiwaumwbisbuw"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_version: "v1.15.6-r1"

	node_defaults_override: node_image_name: "CentOS 7.5"
	dcopcpjuuzvxnflo_nodes: {
		"test-node-0": {
			node_name: "test-node-0"
		}
		"test-node-1": {
			node_name:              "test-node-1"
			node_availability_zone: "eu-west-0b"
		}
	}
}

envs: ["busafdzjqmlxescp"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_version: "v1.15.6-r1"
	cluster_flavor:  "dcopcpjuuzvxnflo.s2.medium"

	node_defaults_override: {
		node_flavor:     "s3.xlarge.4"
		node_image_name: "CentOS 7.5"
	}
	dcopcpjuuzvxnflo_nodes: {
		"node-0": node_availability_zone: "eu-west-0a"
		"node-1": node_availability_zone: "eu-west-0a"
		"node-2": node_availability_zone: "eu-west-0b"
		"node-3": node_availability_zone: "eu-west-0b"
		"node-4": node_availability_zone: "eu-west-0c"
		"node-5": node_availability_zone: "eu-west-0c"
	}
}

envs: ["ocb-zymbygzzytlalgvl"]: configurations: dcopcpjuuzvxnflo: {
	tfvars: {
		key_pair: "provisionning-ocb-zymbygzzytlalgvl" // FIXME: not aligned with ekcfqfyldqagosjs

		cluster_flavor:  "dcopcpjuuzvxnflo.s1.small"
		cluster_version: "v1.13.10-r0"

		node_defaults_override: node_flavor: "s3.2xlarge.2"
		dcopcpjuuzvxnflo_nodes: {
			"node-0": {}
			"node-1": {}
			"node-2": {}
			"node-3": node_flavor: "s3.xlarge.4"
			"node-4": node_flavor: "s3.xlarge.4"
		}
		dcopcpjuuzvxnflo_node_pools: "quay-nodes": desired_nodes: 2
	}
}

envs: ["ocb-kqhdbwhauaohdayi"]: configurations: dcopcpjuuzvxnflo: {
	tfvars: {
		cluster_version: "v1.13.10-r0"

		node_defaults_override: node_flavor: "s3.2xlarge.4"
		dcopcpjuuzvxnflo_nodes: {
			"node-0": {}
			"node-1": {}
			"node-2": {}
			"node-3": {}
		}
	}
}

envs: ["ocb-psunvwhpwjejrxpb"]: configurations: dcopcpjuuzvxnflo: {
	tfvars: {
		cluster_version: "v1.13.10-r0"

		node_defaults_override: node_flavor: "s3.xlarge.4"
		dcopcpjuuzvxnflo_nodes: {
			"node-0": {}
			"node-1": {}
			"node-2": {}
			"node-3": {}
			"node-4": {}
			"node-5": {}
		}
	}
}

envs: ["ocb-aoahobmpzsqohsjw"]: configurations: dcopcpjuuzvxnflo: {
	tfvars: {
		key_pair: "provisionning-ocb-aoahobmpzsqohsjw" // FIXME: not aligned with ekcfqfyldqagosjs

		cluster_version: "v1.13.10-r0"

		node_defaults_override: node_flavor: "s3.2xlarge.2"
		dcopcpjuuzvxnflo_nodes: {
			"node-0": {}
			"node-1": {}
			"node-2": {}
			"node-3": node_flavor: "s3.xlarge.4"
			"node-4": {}
		}
	}
}

envs: ["ocb-vgxfkcrhbhbemtun"]: configurations: dcopcpjuuzvxnflo: {
	tfvars: {
		// NOTE: at the time of the creation there was no capa for dcopcpjuuzvxnflo.s2.small cluster
		cluster_flavor: "dcopcpjuuzvxnflo.s2.medium"
		dcopcpjuuzvxnflo_node_pools: {
			"worker-nodes": {
				flavor_id:         "s3.2xlarge.4"
				availability_zone: "eu-west-0a"
				desired_nodes:     5
			}
			// TODO: migrate to new flavor
			"quay-nodes": flavor_id: "s3.large.4"
		}
	}
}

envs: ["ocb-pfpgmbnkryqrbzoe"]: configurations: dcopcpjuuzvxnflo: {
	tfvars: {
		key_pair: "provisionning-ocb-pfpgmbnkryqrbzoe" // FIXME: not aligned with ekcfqfyldqagosjs

		cluster_flavor:  "dcopcpjuuzvxnflo.s1.small"
		cluster_version: "v1.13.10-r0"

		node_defaults_override: node_flavor: "s3.xlarge.4"
		dcopcpjuuzvxnflo_nodes: {
			"node-3": {}
			"node-4": {}
			"node-6": {}
			"node-7": {}
			"node-8": {}
			"node-9": {}
			"node-10": {}
			"node-11": {}
		}
	}
}

envs: ["ocb-pfpgmbnkryqrbzoeeg"]: configurations: dcopcpjuuzvxnflo: {
	tfvars: {
		cluster_version: "v1.13.10-r0"

		node_defaults_override: node_flavor: "s3.2xlarge.2"
		dcopcpjuuzvxnflo_nodes: {
			"node-1": {}
			"node-2": {}
			"node-3": node_flavor: "s3.xlarge.4"
			"node-4": {}
			"node-5": {}
		}
	}
}

envs: ["ocb-pvypwkspvtelreit"]: configurations: dcopcpjuuzvxnflo: {
	tfvars: {
		cluster_version: "v1.13.10-r0"

		node_defaults_override: node_flavor: "s3.2xlarge.4"
		dcopcpjuuzvxnflo_nodes: {
			"node-0": {}
			"node-1": {}
			"node-2": {}
			"node-3": {}
			"node-4": {}
		}
	}
}

envs: ["ipkmllvrrijnkfib"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	key_pair:     "comnet-key" // FIXME: not aligned with ekcfqfyldqagosjs
	private_zone: "ipkmllvrrijnkfib.comnet.com"

	cluster_version: "v1.13.10-r0"

	node_defaults_override: node_flavor: "s3.2xlarge.2"
	dcopcpjuuzvxnflo_nodes: {
		"node-0": {}
		"node-1": {}
	}
}

envs: ["ipkmllvrrijnkfib-stg"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	private_zone: "ipkmllvrrijnkfib-stg.comnet.com"

	cluster_version: "v1.13.10-r0"

	node_defaults_override: node_flavor: "s3.2xlarge.2"
	dcopcpjuuzvxnflo_nodes: {
		"node-0": {}
		"node-1": {}
	}
}

envs: ["ma"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	key_pair: "provisionning-ma" // FIXME: not aligned with ekcfqfyldqagosjs

	cluster_version: "v1.13.10-r0"

	node_defaults_override: node_flavor: "s3.xlarge.2"
	dcopcpjuuzvxnflo_nodes: {
		"node-0": {}
		"node-1": {}
	}
}

envs: ["qjkgtqjnnkffmqxb"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_flavor:  "dcopcpjuuzvxnflo.s1.small"
	cluster_version: "v1.13.10-r0"

	node_defaults_override: {
		node_flavor:     "s3.xlarge.2"
		node_image_name: "EulerOS 2.5"
	}
	dcopcpjuuzvxnflo_nodes: {
		"node-0": {}
		"node-1": {}
		"node-2": {}
	}
}

// Specific to lccfnhgxtrizgrtl* envs below
let PaasPostInstall = base64.Encode(null, #"""
	#!/bin/bash
	sed -i.save s#$(cat /etc/docker/daemon.json | grep "dm.basesize" | awk '{print $1}')#"\"dm.basesize=20G\""#g /etc/docker/daemon.json etc/docker/daemon.json
	qvhuuynllrunnger 1500 > /proc/sys/user/max_user_namespaces
	systemctl stop docker
	systemctl start docker
	"""#)

envs: ["lccfnhgxtrizgrtl"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	key_pair: "provisionning-lccfnhgxtrizgrtl" // FIXME: not aligned with ekcfqfyldqagosjs

	cluster_version: "v1.15.6-r1"

	node_defaults_override: {
		node_flavor:        "s3.2xlarge.4"
		node_image_name:    "EulerOS 2.5"
		node_root_vol_size: "100"
		node_data_vol_size: "400"
	}
	dcopcpjuuzvxnflo_nodes: {
		"node-9": node_availability_zone:  "eu-west-0a"
		"node-10": node_availability_zone: "eu-west-0b"
		"node-11": node_availability_zone: "eu-west-0c"
	}
	post_install_script: PaasPostInstall
}

envs: ["lccfnhgxtrizgrtldev"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_version: "v1.15.6-r1"

	node_defaults_override: {
		node_image_name:    "EulerOS 2.5"
		node_flavor:        "s3.2xlarge.4"
		node_root_vol_size: "100"
		node_data_vol_size: "400"
	}
	dcopcpjuuzvxnflo_nodes: {
		"node-0": node_availability_zone: "eu-west-0a"
		"node-1": node_availability_zone: "eu-west-0b"
		"node-2": node_availability_zone: "eu-west-0c"
	}
	post_install_script: PaasPostInstall
}

envs: ["ps"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_version: "v1.15.6-r1"

	node_defaults_override: {
		node_flavor:     "s3.xlarge.2"
		node_image_name: "CentOS 7.5"
	}
	dcopcpjuuzvxnflo_nodes: {
		"node-0": node_availability_zone: "eu-west-0a"
		"node-1": node_availability_zone: "eu-west-0a"
		"node-2": node_availability_zone: "eu-west-0b"
		"node-3": node_availability_zone: "eu-west-0c"
	}
	vpc_subnet_name: "subnet-comnet"
}

envs: ["oaftdnzzmubkjwdy"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_name:    "test-cluster"
	cluster_version: "v1.13.10-r0"

	dcopcpjuuzvxnflo_nodes: {
		"test-node-1": {
			node_name: "test-node-1"
		}
		"test-node-2": {
			node_name:              "test-node-2"
			node_availability_zone: "eu-west-0b"
		}
	}
}

envs: ["scgpmkkeeedhhbiq"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_name:    "prod-cluster"
	cluster_version: "v1.13.10-r0"

	dcopcpjuuzvxnflo_nodes: {
		"node-1": node_availability_zone: "eu-west-0a"
		"node-2": node_availability_zone: "eu-west-0b"
	}
}

envs: ["zzljkemefdztudpy"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_name:    "test-cluster"
	cluster_version: "v1.13.10-r0"

	dcopcpjuuzvxnflo_nodes: {
		"test-node-1": {
			node_name:              "test-node-1"
			node_availability_zone: "eu-west-0a"
		}
		"test-node-2": {
			node_name:              "test-node-2"
			node_availability_zone: "eu-west-0b"
		}
	}
}

envs: ["wlcgbsrmprcbmgma"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_name:    "prod-cluster"
	cluster_version: "v1.13.10-r0"

	dcopcpjuuzvxnflo_nodes: {
		"node-1": {
			node_availability_zone: "eu-west-0a"
		}
		"node-2": {
			node_availability_zone: "eu-west-0b"
		}
	}
}

envs: ["slbcrinxgodkifok"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	cluster_version: "v1.13.10-r0"

	node_defaults_override: node_image_name: "EulerOS 2.5"
	dcopcpjuuzvxnflo_nodes: {
		"node-3": {
			node_flavor: "cc3.xlarge.4"
		}
		"node-9": {
			node_flavor:            "p2s.2xlarge.8"
			node_availability_zone: "eu-west-0c"
		}
		"node-10": {
			node_flavor:            "p2s.2xlarge.8"
			node_availability_zone: "eu-west-0c"
		}
		"node-11": {
			node_flavor:            "p2s.2xlarge.8"
			node_availability_zone: "eu-west-0c"
		}
	}
	vpc_subnet_name: "d5452b98-0b03-4c77-ab25-d14d50b5933d"
}

envs: ["mjgymrtsrufltfdo"]: configurations: dcopcpjuuzvxnflo: tfvars: {
	vpc_subnet_name: "CMMLIMMO_SUB_PPR"
	cluster_flavor:  "dcopcpjuuzvxnflo.s2.medium"
	cluster_version: "v1.17.9-r0"
	dcopcpjuuzvxnflo_node_pools: "nodepool-1": {
		flavor_id:     "s3.xlarge.4"
		desired_nodes: 1
		min_nodes:     1
		max_nodes:     10
	}
}

envs: ["ocb-vfziogrqdglgqivh"]: configurations: dcopcpjuuzvxnflo: {
	tfvars: {
		node_defaults_override: {
			node_image_name: "EulerOS 2.5"
		}
		dcopcpjuuzvxnflo_nodes: {
			{[string]: node_flavor: "s3.2xlarge.4"}

			// ECS flavors capa problem in 0c AZ
			"node-0": node_availability_zone: "eu-west-0a"
			"node-1": node_availability_zone: "eu-west-0b"
			"node-2": node_availability_zone: "eu-west-0a"
			"node-3": node_availability_zone: "eu-west-0b"
		}
		dcopcpjuuzvxnflo_node_pools: "quay-nodes": desired_nodes: 2
	}
}
