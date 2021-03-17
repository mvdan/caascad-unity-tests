package zones

zones: {
	"infra-zwtkxvyalrulrfjt": {
		provider: domain_name: "OCB0000000"
		providers: fe: domain_name: "OCB0000000"
		providers: aws:   aws_accounts.comnet_dev
		providers: azure: azure_subscriptions.comnet_staging
		monitoring: {
			logs: comnet: {
				retention: "30d"
				ingester_schema_config: [
					{
						date:    "2018-04-15"
						version: "v9"
						period:  "0h"
					},
					{
						date:    "2020-03-20"
						version: "v11"
						period:  "24h"
					},
					{
						date:    "2020-03-23"
						version: "v11"
						period:  "24h"
					},
				]
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "31d"
					downsampling_1h: "61d"
				}
				consumption: retention: {
					raw:             "15d"
					downsampling_5m: "31d"
					downsampling_1h: "366d"
				}
			}
		}
	}
	"infra-zsgqzvbsvqufttlk": {
		provider: domain_name: "OCB0000000"
		providers: fe:         provider
		providers: aws:        aws_accounts.comnet_prod
		providers: azure:      azure_subscriptions.comnet_prod
		monitoring: {
			logs: comnet: {
				retention: "366d"
				ingester_schema_config: [
					{
						date:    "2020-06-11"
						version: "v11"
						period:  "24h"
					},
				]
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
				consumption: retention: {
					raw:             "60d"
					downsampling_5m: "366d"
					downsampling_1h: "1096d"
				}
			}
		}
	}
}
