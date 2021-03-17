package terraform

envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["msxhfwlczbtpjwkt"]: {
		source: *(#TerraformLib & {
			tag: "msxhfwlczbtpjwkt-v1.1.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/msxhfwlczbtpjwkt"
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		tfvars: {
			zone_name:       zone.name
			domain_name:     zone.domain_name
			infra_zone_name: infra_zone.name
			zones: [string]: content: [ ...#DNSRecord]
			zones: "\(zone.domain_name)":      _
			zones: "\(zone.priv_domain_name)": _
		}
	}
}

#DNSRecord: {
	name: string
	type: *"A" | "AAAA" | "CNAME" | "MX" | "TXT" | "PTR" | "SRV" | "SPF" | "NAPTR" | "CAA" | "NS"
	ttl:  *900 | number
	records: [ ...string]
}

