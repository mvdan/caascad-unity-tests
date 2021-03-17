package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["jzhfhhxedcycwbwx"]: {
		source: *(#TerraformLib & {
			tag: "jzhfhhxedcycwbwx-v1.0.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/jzhfhhxedcycwbwx"

		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		providers: cjppmetyaderslgo: ipkmllvrrijnkfib:                 _
		tfvars: {
			zone_name:      zone.name
			cjppmetyaderslgo_url:      "https://cjppmetyaderslgo.\(infra_zone.name).\(infra_zone.domain_name)"
			fe_domain_name: zone.provider.domain_name
		}

		// FIXME: project deletion doesn't work on FE
		// Just remove the project from the state before destroy so that we can
		// re-use the project later if we need to
		run: actions: pre_destroy: """
			terraform init
			terraform state rm huaweicloud_identity_project_v3.project
			"""
	}
}
