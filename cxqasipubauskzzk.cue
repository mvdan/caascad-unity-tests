package terraform

import (
	"encoding/json"
)

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["ldtznmdomyqeqxdc"]: {
		source: *(#GitSource & {
			url: "https://github.com/Comnet/aws-comnet-roles"
			tag: "v1.1.1"
		}) | #GitSource | #LocalSource
		source: path: "terraform"
		providers: cjppmetyaderslgo: ipkmllvrrijnkfib: _
		tfvars: {
			comnet_operator_trusted_arn: "arn:aws:iam::\(infra_zone.providers.aws.account_id):root"
		}
		// The terraform code for customers doesn't specify any provider
		files: "provider.tf.json": {
			content: json.Marshal({
				provider: cjppmetyaderslgo: {
					address:            "https://cjppmetyaderslgo.ipkmllvrrijnkfib.comnet.com"
					add_address_to_env: true
				}

				data: cjppmetyaderslgo_aws_adcopcpjuuzvxnfloss_credentials: bootstrap: {
					backend: "aws"
					type:    "sts"
					role:    "account_bootstrap_\(zone.name)"
				}

				provider: aws: {
					region:                  "eu-west-3"
					adcopcpjuuzvxnfloss_key: "${data.cjppmetyaderslgo_aws_adcopcpjuuzvxnfloss_credentials.bootstrap.adcopcpjuuzvxnfloss_key}"
					secret_key:              "${data.cjppmetyaderslgo_aws_adcopcpjuuzvxnfloss_credentials.bootstrap.secret_key}"
					token:                   "${data.cjppmetyaderslgo_aws_adcopcpjuuzvxnfloss_credentials.bootstrap.security_token}"
				}
			})
		}
	}
}
