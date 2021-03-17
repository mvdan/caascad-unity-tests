package zones

#AzureSubscription: {
	type:              "azure"
	subscription_name: string
	subscription_id:   =~"[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}"
	tenant_domain:     string
	tenant_id:         =~"[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}"
}

azure_subscriptions: [string]: #AzureSubscription

azure_subscriptions: {
	"comnet_staging": #AzureSubscription & {
		subscription_name: "comnet_staging"
		subscription_id:   "816e6156-87a8-4806-8b6c-9872882f72de"
		tenant_domain:     "b03cce1b-8613-4308-9f33-a02c3f3299ea"
		tenant_id:         "b547b86e-c5f7-4bd2-8e0f-b5c2e550a259"
	}
	"comnet_prod": #AzureSubscription & {
		subscription_name: "comnet_prod"
		subscription_id:   "c81cec39-691f-40d6-8390-8321e63a6d7f"
		tenant_domain:     "931d9e9a-ef15-4581-ba77-190c1164ebe9"
		tenant_id:         "e75cd031-4b96-417e-8907-0e27cfc624cc"
	}
}

for line in #Lines {
	"azure_subscriptions_\(line)": {
		for _, z in zones {
			if z.metadata.line == line && z.provider.type == "azure" {
				"\(z.provider.subscription_name)": z.provider
			}
			if z.type == "infra" && z.metadata.line == line {
				"\(z.providers.azure.subscription_name)": z.providers.azure
			}
		}
	}
}
