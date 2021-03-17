package terraform

import (
	z "comnet.io/zones"
)

envs: [string]: {
	zone: _
	configurations: [=~"^cjppmetyaderslgo_azure_ipkmllvrrijnkfib_comnet"]: {
		source: *(#TerraformLib & {
			tag: "cjppmetyaderslgo_azure_ipkmllvrrijnkfib-v1.0.1"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/cjppmetyaderslgo_azure_ipkmllvrrijnkfib"
		providers: cjppmetyaderslgo: "\(zone.name)": _

		_sub: z.#AzureSubscription

		let AzureLogin = """
			export HOME=$(pwd)
			export VAULT_ADDR=https://cjppmetyaderslgo.\(zone.name).comnet.com
			export USERNAME=$(cjppmetyaderslgo read secret/zones/azure/admin-\(_sub.subscription_name) --format=json | jq -r .data.username)
			export PASSWORD=$(cjppmetyaderslgo read secret/zones/azure/admin-\(_sub.subscription_name) --format=json | jq -r .data.password)
			az login -u $USERNAME -p $PASSWORD --allow-no-subscriptions
			"""
		run: actions: {
			pre_plan:  AzureLogin
			pre_apply: AzureLogin
		}
		tfvars: {
			zone_name:         zone.name
			subscription_id:   _sub.subscription_id
			subscription_name: _sub.subscription_name
			tenant_id:         _sub.tenant_id
		}
	}

}
