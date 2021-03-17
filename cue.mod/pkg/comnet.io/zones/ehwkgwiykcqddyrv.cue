package zones

#AWSAccount: {
	type:         "aws"
	account_name: string
	{
		// Customer AWS accounts
		// They will give us the role arns provisioned by https://github.com/Comnet/aws-comnet-roles
		// The account_id is included in the role arns
		account_id: =~"[0-9]{12}"
		// FIXME: added for conditions in aws_accounts_prod, aws_accounts_dev
		account_name: account_id
		// Example:
		// roles: operator: arn:aws:iam::9323463434:role/comnet-operator
		roles: [string]: string
	} | {
		// Comnet AWS accounts
		// If the account_id is provided we assume the account is already created
		// if not specified the account will be provisioned by some configuration
		account_id?: =~"[0-9]{12}"
		// The name of the account to create
		account_name:  =~"^comnet"
		account_alias: account_name
		ou:            "Comnet_dev_zones" | "Comnet_prod_zones" | "Core"
	}
}

aws_accounts: [string]: #AWSAccount

aws_accounts: {
	comnet_orga: #AWSAccount & {
		account_name: "comnet-orga"
		account_id:   "507171904020"
		ou:           "Core"
	}
	comnet_dev: #AWSAccount & {
		account_name: "comnet"
		account_id:   "481377449749"
		ou:           "Comnet_dev_zones"
	}
	comnet_prod: #AWSAccount & {
		account_name: "comnet-prod"
		account_id:   "374014906619"
		ou:           "Comnet_prod_zones"
	}
	comnet_keayeqshiigjuegy: #AWSAccount & {
		account_name: "comnet-keayeqshiigjuegy"
		ou:           "Comnet_dev_zones"
	}
	comnet_qvhuuynllrunnger: #AWSAccount & {
		account_name: "comnet-qvhuuynllrunnger"
		ou:           "Comnet_dev_zones"
	}
	"comnet_ocb-hzgitwdojgogblpm": #AWSAccount & {
		account_name: "comnet-ocb-hzgitwdojgogblpm"
		ou:           "Comnet_dev_zones"
	}
}

aws_accounts_prod: {
	for _, z in zones
	if z.metadata.prod && z.provider.type == "aws"
	for n, a in aws_accounts
	if (z.provider.account_name != _|_ && z.provider.account_name == a.account_name) {
		"\(n)": a
	}

	for _, z in zones
	if z.type == "infra" && z.metadata.prod
	for n, a in aws_accounts
	if (z.providers.aws.account_name != _|_ && z.providers.aws.account_name == a.account_name) {
		"\(n)": a
	}

	comnet_orga: aws_accounts.comnet_orga
}

aws_accounts_dev: {
	for _, z in zones
	for n, a in aws_accounts
	if !z.metadata.prod && z.provider.type == "aws"
	if (z.provider.account_name != _|_ && z.provider.account_name == a.account_name) {
		"\(n)": a
	}

	for _, z in zones
	if z.type == "infra" && !z.metadata.prod
	for n, a in aws_accounts
	if (z.providers.aws.account_name != _|_ && z.providers.aws.account_name == a.account_name) {
		"\(n)": a
	}
}
