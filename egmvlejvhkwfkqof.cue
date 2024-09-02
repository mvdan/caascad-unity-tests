package terraform

#FEConcourseWorker: {
	flavor_id:       *"s3.large.2" | "s3.xlarge.2"
	concourse_team?: string
	data_disk_size?: >50
}

envs: [string]: {
	zone:        _
	infra_zone:  _
	parent_zone: _
	configurations: ["apzqkrrcwtbaqmwu"]: {
		source: *(#TerraformLib & {
			tag: "apzqkrrcwtbaqmwu-v1.9.1"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/apzqkrrcwtbaqmwu"
		providers: kubernetes: "\(zone.name)":             _
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		tfvars: {
			zone_name:       zone.name
			domain_name:     zone.domain_name
			infra_zone_name: infra_zone.name

			key_pair_name: *envs[zone.name].configurations.ekcfqfyldqagosjs.tfvars.keypair_name | string
			network_name:  *envs[zone.name].configurations.ekcfqfyldqagosjs.tfvars.network_name | string

			route53_secret_backend_name: *"aws" | string
			if infra_zone.name == "infra-zwtkxvyalrulrfjt" {
				route53_secret_backend_name: "aws-prod"
			}

			// This option only work with config version >= v1.9.1
			workers_monitoring_namespace: "comnet-concourse-worker-monitoring"

			if zone.type == "client" {
				concourse_kind:            "client"
				target_zone_name:          parent_zone.name
				target_zone_provider_type: parent_zone.provider.type

				// FIXME: remove this when all configs are >= v1.9.0
				parent_zone_name: parent_zone.name
			}
			if zone.type != "client" {
				concourse_kind:            "infra"
				target_zone_name:          zone.name
				target_zone_provider_type: zone.provider.type
			}
			workers: [string]: #FEConcourseWorker
			workers: [string]: {
				if zone.type == "infra" {
					flavor_id:      "s3.xlarge.2"
					data_disk_size: 300
				}
				if zone.type == "client" {
					concourse_team: *zone.name | string
				}
			}
			workers: "ci-worker-\(zone.name)-0": {}
			if zone.type == "infra" {
				workers: "ci-worker-\(zone.name)-1": {}
			}
		}
	}
}

// Version pinning for some environments.
// We should upgrade all these platform to use the default version.
envs: [=~"^(infra-zwtkxvyalrulrfjt|infra-zsgqzvbsvqufttlk|ocb-oalxziquintsqhht|xladugdwqeqdipbl|gnjpiwaumwbisbuw|busafdzjqmlxescp|ocb-zymbygzzytlalgvl|ocb-kqhdbwhauaohdayi|ocb-psunvwhpwjejrxpb|ocb-aoahobmpzsqohsjw|ocb-pfpgmbnkryqrbzoe|ocb-pfpgmbnkryqrbzoeeg|ocb-pvypwkspvtelreit|ipkmllvrrijnkfib|ipkmllvrrijnkfib-stg|ma|qjkgtqjnnkffmqxb|lccfnhgxtrizgrtl|lccfnhgxtrizgrtldev|oaftdnzzmubkjwdy|scgpmkkeeedhhbiq|zzljkemefdztudpy|wlcgbsrmprcbmgma|slbcrinxgodkifok)$"]: configurations: "apzqkrrcwtbaqmwu": {
	source: tag: "apzqkrrcwtbaqmwu-v1.8.1"
}
envs: ["ps"]: configurations: "apzqkrrcwtbaqmwu": {
	source: tag: "apzqkrrcwtbaqmwu-v1.8.2"
}

// Specify bigger flavor for some zones
envs: [=~"^(ttvvzubrxywbjxob|busafdzjqmlxescp|ipkmllvrrijnkfib|ipkmllvrrijnkfib-stg|ma|qjkgtqjnnkffmqxb|lccfnhgxtrizgrtl|lccfnhgxtrizgrtldev|ps)$"]: configurations: "apzqkrrcwtbaqmwu": {
	tfvars: workers: [string]: flavor_id: "s3.xlarge.2"
}

// Specific overrides on zones
envs: ["ps"]: configurations: "apzqkrrcwtbaqmwu": tfvars: {
	network_name: "411ba502-2ff3-4562-b67c-d87de0ed7091"
	network_id:   "c786e2f2-46e3-4352-bd5e-e5d8e8c294fa"
}
envs: ["slbcrinxgodkifok"]: configurations: "apzqkrrcwtbaqmwu": tfvars: {
	network_name: "d5452b98-0b03-4c77-ab25-d14d50b5933d"
}
envs: ["oaftdnzzmubkjwdy"]: configurations: "apzqkrrcwtbaqmwu": tfvars: {
	key_pair_name: "provisioning-oaftdnzzmubkjwdy"
}
envs: ["mjgymrtsrufltfdo"]: configurations: "apzqkrrcwtbaqmwu": tfvars: {
	network_name: "7fc33f38-5f4c-435a-a78e-e672f9067674"
	network_id:   "1165bc20-9cca-4f58-93d6-5123211e2786"
}

envs: [=~"^(zzljkemefdztudpy|oaftdnzzmubkjwdy|scgpmkkeeedhhbiq|wlcgbsrmprcbmgma)$"]: configurations: "apzqkrrcwtbaqmwu": {
	tfvars: secgroup_egress_allow_all: false
	tfvars: secgroup_egress_rules: {
		"all-http": {
			protocol:         "tcp"
			port_range_min:   80
			port_range_max:   80
			remote_ip_prefix: "127.0.0.1/0"
		}
		"all-https": {
			protocol:         "tcp"
			port_range_min:   443
			port_range_max:   443
			remote_ip_prefix: "127.0.0.1/0"
		}
		"all-concourse": {
			protocol:         "tcp"
			port_range_min:   2222
			port_range_max:   2222
			remote_ip_prefix: "127.0.0.1/0"
		}
		"all-dns-tcp": {
			protocol:         "tcp"
			port_range_min:   53
			port_range_max:   53
			remote_ip_prefix: "127.0.0.1/0"
		}
		"all-dns-udp": {
			protocol:         "udp"
			port_range_min:   53
			port_range_max:   53
			remote_ip_prefix: "127.0.0.1/0"
		}
		"all-ntp-tcp": {
			protocol:         "tcp"
			port_range_min:   123
			port_range_max:   123
			remote_ip_prefix: "127.0.0.1/0"
		}
		"all-ntp-udp": {
			protocol:         "udp"
			port_range_min:   123
			port_range_max:   123
			remote_ip_prefix: "127.0.0.1/0"
		}
	}
}
