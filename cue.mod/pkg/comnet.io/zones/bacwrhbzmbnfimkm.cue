package zones

#DurationDays:  =~"^[0-9]+d"
#DurationHours: =~"^[0-9]+h"

#ProviderFE: {
	type:        "fe"
	domain_name: =~"^OCB[0-9]{7}"
	region:      *"eu-west-0" | "eu-west-1" | "na-east-0"
}
#ProviderAWS: {
	#AWSAccount
	vpc_id?: string
	region:  *"eu-west-3" | string
}

#MonitoringMetrics: {
	retention: {
		raw:             #DurationDays
		downsampling_5m: #DurationDays
		downsampling_1h: #DurationDays
	}
}

#IngesterSchemaConfig: {
	date:    =~"[0-9]{4}-[0-9]{2}-[0-9]{2}"
	version: =~"^v[0-9]+"
	period:  #DurationHours
}

#MonitoringLogs: {
	retention: #DurationDays
	ingester_schema_config: [...#IngesterSchemaConfig]
}

#MonitoringAlerting: {
	// FIXME: specifying disjunctions here triggers a bug.
	// https://github.com/cuelang/cue/issues/770
	duty:     string // "supervision" | "product"
	schedule: string // "HO" | "HNO"
}
#Lines: [ "prod", "staging"]

#ZoneMetadata: {
	prod: bool
	line: or(#Lines)
}

// Common fields used in all zones types
#Zone: {
	type:             "infra" | "cloud" | "client"
	name:             string
	metadata:         #ZoneMetadata
	domain_name:      *"comnet.com" | "comnetpriv.com"
	priv_domain_name: *"comnet.net" | "comnetpriv.net"
	provider:         #ProviderFE | #ProviderAWS | #AzureSubscription
	infra_zone_name:  string
	child_zone_names: [...string]
	monitoring: alerting: #MonitoringAlerting
}

// Specific definition for infra zones
#InfraZone: {
	// This embeds fields of the #Zone def in this #InfraZone def.
	#Zone
	type: "infra"
	// An infra zone name starts with `infra-`
	name: =~"^infra-"
	// The providers that can be used for the cloud zones managed by the infra zone.
	providers: {
		fe:    #ProviderFE
		aws:   #AWSAccount
		azure: #AzureSubscription
	}
	monitoring: {
		alerting: #MonitoringAlerting
		logs: {
			comnet: #MonitoringLogs
		}
		metrics: {
			comnet:     #MonitoringMetrics
			consumption: #MonitoringMetrics
		}
	}
}

// Specific definition for cloud zones
#CloudZone: {
	#Zone
	type: "cloud"
	// A cloud zone name starts with `ocb-`
	name:             =~"^ocb-"
	parent_zone_name: string
	monitoring: {
		alerting: #MonitoringAlerting
		logs: {
			comnet: #MonitoringLogs
			client:  #MonitoringLogs
		}
		metrics: {
			comnet: #MonitoringMetrics
			client:  #MonitoringMetrics
			app:     #MonitoringMetrics
		}
	}
}

// Specific definition for client zones
#ClientZone: {
	#Zone
	type:             "client"
	parent_zone_name: string
}

zones: [Name=string]: name: Name

zones: [Name= =~"^infra-"]: #InfraZone & {
	infra_zone_name: Name
	// Compute list of children zones of the current infra zone
	child_zone_names: [
		for n, z in zones
		if z.type == "cloud"
		if z.parent_zone_name == Name {n},
	]

	if Name == "infra-zsgqzvbsvqufttlk" {
		metadata: {
			prod: true
			line: "prod"
		}

		monitoring: alerting: {
			duty:     *"supervision" | string
			schedule: *"HNO" | string
		}
	}
	if Name == "infra-zwtkxvyalrulrfjt" {
		metadata: {
			prod: false
			line: "staging"
		}

		monitoring: alerting: {
			duty:     *"supervision" | string
			schedule: *"HO" | string
		}
	}
}

zones: [Name= =~"^ocb-"]: #CloudZone & {
	parent_zone_name: string
	// Get the definition of the parent infra zone
	let ParentZone = zones[parent_zone_name]

	// By default the cloud zone is in the same FE domain as the parent infra zone
	provider: *ParentZone.providers.fe | #ProviderFE | #ProviderAWS | #AzureSubscription

	// DNS domain names are the same as the parent infra zone
	domain_name:      ParentZone.domain_name
	priv_domain_name: ParentZone.priv_domain_name
	infra_zone_name:  ParentZone.name

	// Compute list of children zones of the current cloud zone
	child_zone_names: [
		for n, z in zones
		if z.type == "client"
		if z.parent_zone_name == Name {n},
	]

	metadata: {
		prod: ParentZone.metadata.prod
		line: ParentZone.metadata.line
	}

	// By default take alerting values of the infra zone
	monitoring: alerting: {
		duty:     *ParentZone.monitoring.alerting.duty | string
		schedule: *ParentZone.monitoring.alerting.schedule | string
	}
}

// ocb-test zones and their client zones are managed by product team
zones: [Name= =~"^ocb-test"]: #CloudZone & {
	monitoring: alerting: {
		duty:     "product"
		schedule: "HO"
	}
}

zones: [Name= !~"^(ocb|infra)-"]: #ClientZone & {
	parent_zone_name: string
	// Get the definition of the parent cloud zone
	let ParentZone = zones[parent_zone_name]

	// DNS domain names are the same as the parent cloud zone
	domain_name:      ParentZone.domain_name
	priv_domain_name: ParentZone.priv_domain_name

	// The infra zone is the same as the cloud zone
	infra_zone_name: ParentZone.infra_zone_name

	metadata: {
		prod: ParentZone.metadata.prod
		line: ParentZone.metadata.line
	}

	// By default take alerting values of the cloud zone
	monitoring: alerting: {
		duty:     *ParentZone.monitoring.alerting.duty | string
		schedule: *ParentZone.monitoring.alerting.schedule | string
	}
}
