package terraform

envs: [string]: {
	zone:        _
	infra_zone:  _
	parent_zone: _
	configurations: ["sfkxmhgshgoiaxpr"]: {
		source: *(#TerraformLib & {
			tag: "sfkxmhgshgoiaxpr-v2.2.1"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/sfkxmhgshgoiaxpr"
		providers: kubernetes: "\(zone.name)":  _
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		tfvars: {
			zone_name:           zone.name
			domain_name:         zone.domain_name
			private_domain_name: zone.priv_domain_name
			infra_zone_name:     infra_zone.name

			aws_region: zone.provider.region

			cjppmetyaderslgo_aws_role: envs[zone.name].configurations.cjppmetyaderslgo_aws_sts_roles.tfvars.roles.operator.cjppmetyaderslgo_role_name

			key_pair_name: envs[zone.name].configurations.smymjpkigjwiaxnu.tfvars.keypair_name

			vpc_id:   string
			vpc_name: string
			if (zone.provider.vpc_id == _|_) {
				vpc_id:   ""
				vpc_name: envs[zone.name].configurations.seotfaqctmulanqa.tfvars.vpc_name
			}
			if (zone.provider.vpc_id != _|_) {
				vpc_id:   zone.provider.vpc_id
				vpc_name: ""
			}

			route53_secret_backend_name: *"aws" | string
			if infra_zone.name == "infra-zwtkxvyalrulrfjt" {
				route53_secret_backend_name: "aws-prod"
			}

			workers_monitoring_namespace: "comnet-concourse-worker-monitoring"

			if zone.type == "client" {
				concourse_kind:            "client"
				target_zone_name:          parent_zone.name
				target_zone_provider_type: parent_zone.provider.type
			}
			if zone.type != "client" {
				concourse_kind:            "infra"
				target_zone_name:          zone.name
				target_zone_provider_type: zone.provider.type
			}
			workers: {
				"ci-worker-\(zone.name)-0": {
					flavor_id: *"t3.large" | string
					if zone.type == "client" {
						concourse_team: *zone.name | string
					}
				}
			}
		}
	}
}

envs: [=~"^(qvhuuynllrunnger|keayeqshiigjuegy)$"]: configurations: sfkxmhgshgoiaxpr: tfvars: {
	workers: [string]: flavor_id: "t3.medium"
}
