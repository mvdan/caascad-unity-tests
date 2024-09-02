package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["zsanvdsnathnlyaf"]: {
		source: *(#TerraformLib & {
			tag: "zsanvdsnathnlyaf-v3.0.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/zsanvdsnathnlyaf"
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		tfvars: {
			zone_name:       zone.name
			domain_name:     zone.domain_name
			infra_zone_name: infra_zone.name

			aws_region: zone.provider.region

			cjppmetyaderslgo_aws_role: configurations.cjppmetyaderslgo_aws_sts_roles.tfvars.roles.operator.cjppmetyaderslgo_role_name

			cluster_version: *"1.18" | string

			key_pair: configurations.smymjpkigjwiaxnu.tfvars.keypair_name

			vpc_id:       string
			vpc_name:     string
			cluster_name: string
			if (zone.provider.vpc_id == _|_) {
				vpc_id:       ""
				vpc_name:     configurations.seotfaqctmulanqa.tfvars.vpc_name
				cluster_name: configurations.seotfaqctmulanqa.tfvars.cluster_name
			}
			if (zone.provider.vpc_id != _|_) {
				vpc_id:       zone.provider.vpc_id
				vpc_name:     ""
				cluster_name: zone.provider.cluster_name
			}

			zsanvdsnathnlyaf_node_groups: [string]: {
				ami_type: "AL2_x86_64"
				// Types
				// * t3.2xlarge: 8 CPU, 32G RAM
				// * t3.xlarge: 4 CPU, 16G RAM
				// * t3.large: 2 CPU, 8G RAM
				instance_type: *"t3.2xlarge" | "t3.xlarge" | "t3.large"
				az_list: [...string]
				min_nodes:     *1 | int
				desired_nodes: *3 | int
				max_nodes:     *3 | int
				volume_size:   *100 | int
				labels: *{} | {...}
				taints: [...string]
			}

			zsanvdsnathnlyaf_node_groups: {
				if zone.type == "cloud" || zone.type == "infra" {
					nodes: {
						desired_nodes: 3
						max_nodes:     4
					}
					quay_nodes: {
						instance_type: "t3.large"
						min_nodes:     1
						desired_nodes: 1
						max_nodes:     1
						labels: comnet_node_reserved_app: "quay"
						taints: [
							"comnet_node_reserved_app=quay:NoSchedule",
							"comnet_node_reserved_app=quay:NoExecute",
						]
					}
				}
				if zone.type == "client" {
					worker_nodes: {
						instance_type: "t3.large"
						desired_nodes: 2
					}
				}
			}
		}
		// When not in bootstrap mode (first-install)
		// we might need to cordon nodes before running apply
		if !bootstrap {
			providers: kubernetes: "\(zone.name)": _
		}
		run: {
			options: output_dir: string
			if options.output_dir != "" {
				// When we have a plan to apply check if some node group will be recreated
				// If yes cordon all nodes belonging to the node group
				actions: pre_apply: """
					for node_group in $(jq -r '.resource_changes[] | select(.type == "aws_zsanvdsnathnlyaf_node_group") | select(.change.actions == ["create", "delete"]) | .change.before.node_group_name' <\(options.output_dir)/plan.json)
					do
						for node in $(kubectl get nodes -l "zsanvdsnathnlyaf.amazonaws.com/nodegroup=${node_group}" -o=jsonpath='{.items[*].metadata.name}')
						do
							kubectl cordon "${node}"
						done
					done
					"""
			}
		}
	}
}
