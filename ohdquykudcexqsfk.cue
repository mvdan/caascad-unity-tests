package terraform

import (
	z "comnet.io/zones"
	tb "comnet.io/trackbone"
)

let Zones = z.zones

bootstrap: *false | true @tag(bootstrap,type=bool)

line: *"all" | string @tag(line,short=prod|staging)

#EnvInfra: tb.#Env & {
	zone:       _
	infra_zone: _
	configurations: close({
		tgdthifiuygwkuvd:                          tb.#TFConfig
		dtmyfegilaxrvzuc:                          tb.#TFConfig
		ekcfqfyldqagosjs:                          tb.#TFConfig
		lvujjitqpazwkvop:                          #TFConfig
		rwuzkqovopspvomc:                          tb.#TFConfig
		msxhfwlczbtpjwkt:                          tb.#TFConfig
		dcopcpjuuzvxnflo:                          tb.#TFConfig
		fxhrnkeurlewsyfn:                          tb.#TFConfig
		lvnhynxhvptukwuq:                          #AnsibleConfig
		swzwzaxyyidyzysm:                          tb.#TFConfig
		xnvpoifrpqbpdrjn:                          tb.#TFConfig
		"byzbcddzcjthnazj":                        tb.#HelmConfig
		csbhovxlbadjlhuw:                          tb.#HelmConfig
		txaceehiueynutdu:                          tb.#HelmConfig
		ingress_controller_private:                tb.#HelmConfig
		"bujzeovffefijufa":                        tb.#TFConfig
		cjppmetyaderslgo:                          tb.#HelmConfig
		tczfxjfecbzgxqeq:                          tb.#HelmConfig
		"tczfxjfecbzgxqeq-cjppmetyaderslgo-infra": tb.#TFConfig
		"tpbwlnzycmzeoyfi":                        tb.#HelmConfig
		if zone.metadata.line == "prod" {
			rrboyqsjnqwlqdys: tb.#TFConfig
		}
		if zone.metadata.line == "staging" {
			"mougprigxfirxlad": tb.#TFConfig
		}
		pnjicteepvblcvub:                  tb.#HelmConfig
		nkpqmhmopbjlhrgs:                  tb.#HelmConfig
		"apzqkrrcwtbaqmwu":                tb.#TFConfig
		todlrceqzsfstqnz:                  tb.#TFConfig
		quvxqpfzejqzfbrk:                  tb.#TFConfig
		qdjiggzhpimmwyzi:                  tb.#TFConfig
		gcboiaxyxephlody:                  tb.#TFConfig
		cjppmetyaderslgo_aws_sts_infra:    tb.#TFConfig
		zmadaoqrnwtuymsd:                  tb.#TFConfig
		"nrmnfyizhlmufpht":                tb.#HelmConfig
		"pmlsymxcfqykyxgw":                tb.#HelmConfig
		"pmlsymxcfqykyxgw-servicemonitor": #ComnetServicemonitorHelmConfig
		vsuvlqcoycxyhxdu:                  #ConcourseHelmConfig
		wbeglgblcrlfskiy:                  tb.#TFConfig
		cjppmetyaderslgo_aws_sts_roles:    tb.#TFConfig
		iteciireojbigwpe:                  tb.#HelmConfig
		"wpkeypipxxjfjnsg":                tb.#HelmConfig
		"psssgdvldainnjre":                #ComnetServicemonitorHelmConfig
		"omqqscnuljhspdwm":                #ComnetServicemonitorHelmConfig
		"psssgdvldainnjre-federate":       #ComnetServicemonitorHelmConfig
	})
}

#EnvCloudFE: tb.#Env & {
	zone:       _
	infra_zone: _
	configurations: close({
		jzhfhhxedcycwbwx:           tb.#TFConfig
		ekcfqfyldqagosjs:           tb.#TFConfig
		lvujjitqpazwkvop:           #TFConfig
		swzwzaxyyidyzysm:           tb.#TFConfig
		rwuzkqovopspvomc:           tb.#TFConfig
		dcopcpjuuzvxnflo:           tb.#TFConfig
		fxhrnkeurlewsyfn:           tb.#TFConfig
		lvnhynxhvptukwuq:           #AnsibleConfig
		xnvpoifrpqbpdrjn:           tb.#TFConfig
		"byzbcddzcjthnazj":         tb.#HelmConfig
		csbhovxlbadjlhuw:           tb.#HelmConfig
		txaceehiueynutdu:           tb.#HelmConfig
		ingress_controller_private: tb.#HelmConfig
		ingress_controller_public:  tb.#HelmConfig
		if zone.name == "ocb-vfziogrqdglgqivh" {
			tshzetpznsktkvxv: tb.#TFConfig
		}
		"cjppmetyaderslgo-cloud-kms":              tb.#TFConfig
		cjppmetyaderslgo:                          tb.#HelmConfig
		tczfxjfecbzgxqeq:                          tb.#HelmConfig
		"tczfxjfecbzgxqeq-cjppmetyaderslgo-cloud": tb.#TFConfig
		cjppmetyaderslgo_aws_sts_cloud:            tb.#TFConfig
		"tpbwlnzycmzeoyfi":                        tb.#HelmConfig
		if zone.metadata.line == "prod" {
			rrboyqsjnqwlqdys: tb.#TFConfig
		}
		if zone.metadata.line == "staging" {
			"rrboyqsjnqwlqdys-cloud": tb.#TFConfig
		}
		pnjicteepvblcvub:                  tb.#HelmConfig
		nkpqmhmopbjlhrgs:                  tb.#HelmConfig
		"apzqkrrcwtbaqmwu":                tb.#TFConfig
		qdjiggzhpimmwyzi:                  tb.#TFConfig
		"nrmnfyizhlmufpht":                tb.#HelmConfig
		"pmlsymxcfqykyxgw":                tb.#HelmConfig
		"pmlsymxcfqykyxgw-servicemonitor": #ComnetServicemonitorHelmConfig
		vsuvlqcoycxyhxdu:                  #ConcourseHelmConfig
		jreguddlvoheaxlk:                  #ConcourseHelmConfig
		iteciireojbigwpe:                  tb.#HelmConfig
		"wpkeypipxxjfjnsg":                tb.#HelmConfig
		"govdevaxtdjwwawc":                #ComnetServicemonitorHelmConfig
		"isdvrilyginwbowp":                #ComnetServicemonitorHelmConfig
		"yoeagsedgebxcgyg":                #ComnetServicemonitorHelmConfig
		"govdevaxtdjwwawc-federate":       #ComnetServicemonitorHelmConfig
		"isdvrilyginwbowp-federate":       #ComnetServicemonitorHelmConfig
	})
}

#EnvCloudAWS: tb.#Env & {
	zone:       _
	infra_zone: _
	configurations: close ({
		todlrceqzsfstqnz_rules:                    tb.#TFConfig
		tqiqsmvypugfqwsb:                          tb.#TFConfig
		wbeglgblcrlfskiy:                          tb.#TFConfig
		ldtznmdomyqeqxdc:                          tb.#TFConfig
		cjppmetyaderslgo_aws_sts_roles:            tb.#TFConfig
		seotfaqctmulanqa:                          tb.#TFConfig
		smymjpkigjwiaxnu:                          tb.#TFConfig
		qxxixpswrmhalwdt:                          #TFConfig
		zsanvdsnathnlyaf:                          tb.#TFConfig
		fxhrnkeurlewsyfn:                          tb.#TFConfig
		lvnhynxhvptukwuq:                          #AnsibleConfig
		vbhsacluzdvcwsjt:                          tb.#TFConfig
		"byzbcddzcjthnazj":                        tb.#HelmConfig
		csbhovxlbadjlhuw:                          tb.#HelmConfig
		txaceehiueynutdu:                          tb.#HelmConfig
		ingress_controller_private:                tb.#HelmConfig
		ingress_controller_public:                 tb.#HelmConfig
		"cjppmetyaderslgo-cloud-kms":              tb.#TFConfig
		cjppmetyaderslgo:                          tb.#HelmConfig
		tczfxjfecbzgxqeq:                          tb.#HelmConfig
		"tczfxjfecbzgxqeq-cjppmetyaderslgo-cloud": tb.#TFConfig
		cjppmetyaderslgo_aws_sts_cloud:            tb.#TFConfig
		"tpbwlnzycmzeoyfi":                        tb.#HelmConfig
		if zone.metadata.line == "prod" {
			rrboyqsjnqwlqdys: tb.#TFConfig
		}
		if zone.metadata.line == "staging" {
			"rrboyqsjnqwlqdys-cloud": tb.#TFConfig
		}
		pnjicteepvblcvub:            tb.#HelmConfig
		nkpqmhmopbjlhrgs:            tb.#HelmConfig
		sfkxmhgshgoiaxpr:            tb.#TFConfig
		qdjiggzhpimmwyzi:            tb.#TFConfig
		"nrmnfyizhlmufpht":          tb.#HelmConfig
		vsuvlqcoycxyhxdu:            #ConcourseHelmConfig
		jreguddlvoheaxlk:            #ConcourseHelmConfig
		iteciireojbigwpe:            tb.#HelmConfig
		"wpkeypipxxjfjnsg":          tb.#HelmConfig
		"govdevaxtdjwwawc":          #ComnetServicemonitorHelmConfig
		"isdvrilyginwbowp":          #ComnetServicemonitorHelmConfig
		"yoeagsedgebxcgyg":          #ComnetServicemonitorHelmConfig
		"govdevaxtdjwwawc-federate": #ComnetServicemonitorHelmConfig
		"isdvrilyginwbowp-federate": #ComnetServicemonitorHelmConfig
	})
}

#EnvClientFE: tb.#Env & {
	zone:       _
	infra_zone: _
	configurations: close({
		if infra_zone.name == "infra-zwtkxvyalrulrfjt" {
			jzhfhhxedcycwbwx: tb.#TFConfig
		}
		ekcfqfyldqagosjs: tb.#TFConfig
		lvujjitqpazwkvop: #TFConfig
		dcopcpjuuzvxnflo: tb.#TFConfig
		if zone.metadata.line == "staging" {
			"rrboyqsjnqwlqdys-client": tb.#TFConfig
		}
		lvnhynxhvptukwuq:   #AnsibleConfig
		pnjicteepvblcvub:   tb.#HelmConfig
		nkpqmhmopbjlhrgs:   tb.#HelmConfig
		"nrmnfyizhlmufpht": tb.#HelmConfig
		"apzqkrrcwtbaqmwu": tb.#TFConfig
	})
}

#EnvClientAWS: tb.#Env & {
	zone:       _
	infra_zone: _
	configurations: close({
		if zone.provider.account_name == "comnet-\(zone.name)" && zone.provider.account_id == _|_ {
			todlrceqzsfstqnz_rules: tb.#TFConfig
			tqiqsmvypugfqwsb:       tb.#TFConfig
			wbeglgblcrlfskiy:       tb.#TFConfig
			ldtznmdomyqeqxdc:       tb.#TFConfig
		}

		cjppmetyaderslgo_aws_sts_roles: tb.#TFConfig

		if zone.provider.vpc_id == _|_ {
			seotfaqctmulanqa: tb.#TFConfig
		}

		smymjpkigjwiaxnu: tb.#TFConfig
		qxxixpswrmhalwdt: #TFConfig
		zsanvdsnathnlyaf: tb.#TFConfig
		if zone.metadata.line == "staging" {
			"rrboyqsjnqwlqdys-client": tb.#TFConfig
		}
		lvnhynxhvptukwuq:   #AnsibleConfig
		pnjicteepvblcvub:   tb.#HelmConfig
		nkpqmhmopbjlhrgs:   tb.#HelmConfig
		"nrmnfyizhlmufpht": tb.#HelmConfig
		sfkxmhgshgoiaxpr:   tb.#TFConfig
	})
}

#EnvCorp: tb.#Env & {
	zone:       _
	infra_zone: _
	configurations: close({
		jzhfhhxedcycwbwx: tb.#TFConfig
		ekcfqfyldqagosjs: tb.#TFConfig
		lvujjitqpazwkvop: #TFConfig
		swzwzaxyyidyzysm: tb.#TFConfig
		rwuzkqovopspvomc: tb.#TFConfig
		dcopcpjuuzvxnflo: tb.#TFConfig
		if zone.metadata.line == "staging" {
			"rrboyqsjnqwlqdys-client": tb.#TFConfig
		}
		"byzbcddzcjthnazj":                                   tb.#HelmConfig
		csbhovxlbadjlhuw:                                     tb.#HelmConfig
		fxhrnkeurlewsyfn:                                     tb.#TFConfig
		lvnhynxhvptukwuq:                                     #AnsibleConfig
		pnjicteepvblcvub:                                     tb.#HelmConfig
		nkpqmhmopbjlhrgs:                                     tb.#HelmConfig
		xnvpoifrpqbpdrjn:                                     tb.#TFConfig
		"apzqkrrcwtbaqmwu":                                   tb.#TFConfig
		txaceehiueynutdu:                                     tb.#HelmConfig
		ingress_controller_private:                           tb.#HelmConfig
		ingress_controller_public:                            tb.#HelmConfig
		"bujzeovffefijufa":                                   tb.#TFConfig
		tczfxjfecbzgxqeq:                                     tb.#HelmConfig
		"tczfxjfecbzgxqeq-cjppmetyaderslgo-ipkmllvrrijnkfib": tb.#TFConfig
		cjppmetyaderslgo_aws_sts_ipkmllvrrijnkfib:            tb.#TFConfig
		qdjiggzhpimmwyzi:                                     tb.#TFConfig
		"nrmnfyizhlmufpht":                                   tb.#HelmConfig
		gkqwkkcalybyefyk:                                     tb.#TFConfig
		wbeglgblcrlfskiy_comnet_orga:                         tb.#TFConfig
		iteciireojbigwpe:                                     tb.#HelmConfig
		iyphjdnvrvpkizcu:                                     tb.#HelmConfig
		feaotlcttwmxdbdh:                                     tb.#TFConfig
		// Generate one config per comnet subscription
		for _, s in z.azure_subscriptions if s.subscription_name =~ "^comnet" {
			"cjppmetyaderslgo_azure_ipkmllvrrijnkfib_\(s.subscription_name)": tb.#TFConfig & {_sub: s}
		}
	})
}

#EnvCorpStg: tb.#Env & {
	zone:       _
	infra_zone: _
	configurations: close({
		jzhfhhxedcycwbwx: tb.#TFConfig
		ekcfqfyldqagosjs: tb.#TFConfig
		lvujjitqpazwkvop: #TFConfig
		swzwzaxyyidyzysm: tb.#TFConfig
		rwuzkqovopspvomc: tb.#TFConfig
		dcopcpjuuzvxnflo: tb.#TFConfig
		if zone.metadata.line == "staging" {
			"rrboyqsjnqwlqdys-client": tb.#TFConfig
		}
		csbhovxlbadjlhuw:           tb.#HelmConfig
		fxhrnkeurlewsyfn:           tb.#TFConfig
		"byzbcddzcjthnazj":         tb.#HelmConfig
		lvnhynxhvptukwuq:           #AnsibleConfig
		pnjicteepvblcvub:           tb.#HelmConfig
		nkpqmhmopbjlhrgs:           tb.#HelmConfig
		"nrmnfyizhlmufpht":         tb.#HelmConfig
		"apzqkrrcwtbaqmwu":         tb.#TFConfig
		txaceehiueynutdu:           tb.#HelmConfig
		ingress_controller_private: tb.#HelmConfig
		ingress_controller_public:  tb.#HelmConfig
		iyphjdnvrvpkizcu:           tb.#HelmConfig
	})
}

// Import envs from comnet-zones
envs: {
	for n, z in Zones
	if line == "all" || z.metadata.line == line {
		"\(n)": {
			zone:       z
			infra_zone: Zones[z.infra_zone_name]
			if z.type != "infra" {
				parent_zone: Zones[z.parent_zone_name]
			}
			if z.type == "infra" {
				parent_zone: infra_zone
			}
		}
		if z.type == "infra" {
			"\(n)": #EnvInfra
		}
		if z.type == "cloud" && z.provider.type == "fe" {
			"\(n)": #EnvCloudFE
		}
		if z.type == "cloud" && z.provider.type == "aws" {
			"\(n)": #EnvCloudAWS
		}
		if z.type == "client" && z.provider.type == "fe" && z.name != "ipkmllvrrijnkfib" && z.name != "ipkmllvrrijnkfib-stg" {
			"\(n)": #EnvClientFE
		}
		if z.type == "client" && z.provider.type == "aws" {
			"\(n)": #EnvClientAWS
		}
		if z.name == "ipkmllvrrijnkfib" {
			"\(n)": #EnvCorp
		}
		if z.name == "ipkmllvrrijnkfib-stg" {
			"\(n)": #EnvCorpStg
		}
	}
}

envs: [ZoneName=string]: {
	name:       ZoneName
	infra_zone: _
	configurations: [ConfigName=string]: {
		type: string

		secrets: [SourceZoneName=string]: {
			let SourceZone = Zones[SourceZoneName]
			zone_name:   SourceZoneName
			domain_name: SourceZone.domain_name
		}
		// Client to the current infra zone
		secrets: "\(infra_zone.name)": {}

		providers: [string]: [ZoneName=string]: {
			zone_name: ZoneName
			creds: source: infra_zone.name
		}
		providers: cjppmetyaderslgo: [ZoneName=string]: {
			let Zone = Zones[ZoneName]
			creds: secret_path: "secret/zones/\(Zone.provider.type)/\(Zone.name)/cjppmetyaderslgo-admin-approle"
		}
		providers: kubernetes: [ZoneName=string]: {
			creds: secret_path: "secret/concourse-infra/global/kubernetes-\(ZoneName)"
		}

		if type == "terraform" {
			backend: {
				type: "s3"
				params: {
					bucket:         "\(infra_zone.name)-\(infra_zone.providers.aws.account_id)-tf-states"
					key:            "\(ZoneName)/\(ConfigName)/terraform.tfstate"
					region:         "eu-west-3"
					dynamodb_table: "\(infra_zone.name)-\(infra_zone.providers.aws.account_id)-tf-locks"
					creds: {
						source:      infra_zone.name
						secret_path: "aws/sts/power_user_\(infra_zone.name)"
					}
				}
			}
		}
	}
}
