package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["ekcfqfyldqagosjs"]: {
		source: *(#TerraformLib & {
			tag: "ekcfqfyldqagosjs-v3.1.0"
		}) | #TerraformLib | #LocalSource
		// Set as the default value as it needs to be different for slbcrinxgodkifok
		source: path: *"configurations/ekcfqfyldqagosjs" | string
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		providers: cjppmetyaderslgo: ipkmllvrrijnkfib:                 _
		tfvars: {
			zone_name:       zone.name
			domain_name:     zone.domain_name
			infra_zone_name: infra_zone.name

			route53_secret_backend_name: *"aws" | "aws-prod"
			if infra_zone.name == "infra-zwtkxvyalrulrfjt" {
				route53_secret_backend_name: "aws-prod"
			}

			// Used to create route53 AK/SK (all in prod account)
			cjppmetyaderslgo_aws_iam_role: "account_bootstrap_374014906619"

			dns_nameservers: *["127.0.0.1", "127.0.0.1"] | [...string]
			network_name:    *"comnet-\(zone.name)-network" | string
			subnet_name:     *"comnet-\(zone.name)-subnet" | string
			subnet_cidr:     *"127.0.0.1/16" | string
			router_name:     *"comnet-\(zone.name)-router" | string
			nat_gw_name:     *"comnet-\(zone.name)-gw" | string
			keypair_name:    *"provisioning-\(zone.name)" | string
			nat_gw_spec:     *"1" | "2" | "3" | "4" // for Small, Medium, Large, Extra-Large
		}
	}
}

// Old inputs
envs: [=~"^(infra-zwtkxvyalrulrfjt|infra-zsgqzvbsvqufttlk|ocb-ilpybubiybhtluxw|ocb-oalxziquintsqhht|eerryhrhvgbduosx|unepmqybzvtwmyjx|hszqlstppgwrbexx|xladugdwqeqdipbl|gnjpiwaumwbisbuw|ocb-kqhdbwhauaohdayi|ocb-psunvwhpwjejrxpb|ocb-aoahobmpzsqohsjw|ocb-zymbygzzytlalgvl|ipkmllvrrijnkfib|ocb-pfpgmbnkryqrbzoe|ma|lccfnhgxtrizgrtl|ps|qjkgtqjnnkffmqxb|ocb-pfpgmbnkryqrbzoeeg|slbcrinxgodkifok)$"]: configurations: ekcfqfyldqagosjs: tfvars: {
	network_name: "comnet-network"
	subnet_name:  "comnet-subnet"
	router_name:  "comnet_router"
	nat_gw_name:  "comnet_gw"
}

envs: ["busafdzjqmlxescp"]: configurations: ekcfqfyldqagosjs: tfvars: {
	network_name: "comnet_busafdzjqmlxescp_network"
	subnet_name:  "comnet_busafdzjqmlxescp_subnet"
	router_name:  "comnet_busafdzjqmlxescp_router"
	nat_gw_name:  "comnet_busafdzjqmlxescp_gw"
}

// FIXME: configuration was applied partially
envs: [=~"^(wlcgbsrmprcbmgma|scgpmkkeeedhhbiq|mjgymrtsrufltfdo)"]: configurations: ekcfqfyldqagosjs: {
	env_vars: {
		TF_CLI_ARGS_plan:  "-target flexibleengine_compute_keypair_v2.provisioning-keypair -target module.private_dns_zone -target module.public_dns_zone"
		TF_CLI_ARGS_apply: TF_CLI_ARGS_plan
	}
}

envs: ["wlcgbsrmprcbmgma"]: configurations: ekcfqfyldqagosjs: tfvars: {
	network_name: "e43f9c87-e36d-479c-806f-a87584d40408"
	subnet_name:  "d5452b98-0b03-4c77-ab25-d14d50b5933d"
}

envs: ["scgpmkkeeedhhbiq"]: configurations: ekcfqfyldqagosjs: tfvars: {
	network_name: "86b0c85c-cc98-489c-b45c-776bb274a62c"
	subnet_name:  "d5452b98-0b03-4c77-ab25-d14d50b5933d"
}

envs: ["zzljkemefdztudpy"]: configurations: ekcfqfyldqagosjs: {
	tfvars: {
		network_name: "40c85a70-cb65-40b9-bb1a-80d0d7d13278"
		subnet_name:  "d5452b98-0b03-4c77-ab25-d14d50b5933d"
		keypair_name: "d5452b98-0b03-4c77-ab25-d14d50b5933d"
	}
	// FIXME: ekcfqfyldqagosjs has not been run on this env
	run: actions: pre_plan:  "exit 0"
	run: actions: pre_apply: "exit 0"
}

envs: ["oaftdnzzmubkjwdy"]: configurations: ekcfqfyldqagosjs: {
	tfvars: {
		network_name: "a2de3ca6-dff4-409c-b8ff-6cc22afb056c"
		subnet_name:  "d5452b98-0b03-4c77-ab25-d14d50b5933d"
		keypair_name: "d5452b98-0b03-4c77-ab25-d14d50b5933d"
	}
	// FIXME: ekcfqfyldqagosjs has not been run on this env
	run: actions: pre_plan:  "exit 0"
	run: actions: pre_apply: "exit 0"
}

envs: ["slbcrinxgodkifok"]: configurations: ekcfqfyldqagosjs: {
	source: {
		tag:  "slbcrinxgodkifok_base-v2.1.0"
		path: "configurations/slbcrinxgodkifok_base"
	}
	tfvars: {
		subnet_cidr: "127.0.0.1/24"
	}
}
