package terraform

envs: [string]: {
	zone: _
	configurations: ["bujzeovffefijufa"]: {
		source: *(#TerraformLib & {
			tag: "bujzeovffefijufa-v2.0.1"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/bujzeovffefijufa"
		providers: cjppmetyaderslgo: ipkmllvrrijnkfib:                _
		providers: kubernetes: "\(zone.name)": _
		tfvars: {
			zone_name: zone.name

			cjppmetyaderslgo_address: "https://cjppmetyaderslgo.ipkmllvrrijnkfib.comnet.com"

			// FIXME: migrate cjppmetyaderslgo-ipkmllvrrijnkfib and cjppmetyaderslgo-infra-zsgqzvbsvqufttlk in their respective accounts
			cjppmetyaderslgo_aws_sts_role: "power_user_comnet"

			aws_region: "eu-west-3"
		}
	}
}
