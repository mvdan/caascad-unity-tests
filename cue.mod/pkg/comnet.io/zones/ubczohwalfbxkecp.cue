package zones

zones: {
	"ocb-kqhdbwhauaohdayi": {
		parent_zone_name: "infra-zsgqzvbsvqufttlk"
		monitoring: {
			logs: {
				comnet: {
					retention: "60d"
					ingester_schema_config: [
						{
							date:    "2020-10-16"
							version: "v11"
							period:  "24h"
						},
					]
				}
				client: {
					retention: "30d"
					ingester_schema_config: [
						{
							date:    "2020-10-16"
							version: "v11"
							period:  "24h"
						},
					]
				}
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
				client: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "190d"
				}
				app: retention: {
					raw:             "15d"
					downsampling_5m: "30d"
					downsampling_1h: "60d"
				}
			}
		}
	}
	busafdzjqmlxescp: {
		parent_zone_name: "ocb-kqhdbwhauaohdayi"
		provider:         zones[parent_zone_name].provider
	}
	"ocb-psunvwhpwjejrxpb": {
		parent_zone_name: "infra-zsgqzvbsvqufttlk"
		monitoring: {
			logs: {
				comnet: {
					retention: "60d"
					ingester_schema_config: [
						{
							date:    "2020-05-07"
							version: "v11"
							period:  "24h"
						},
					]
				}
				client: {
					retention: "1825d"
					ingester_schema_config: [
						{
							date:    "2020-06-11"
							version: "v11"
							period:  "24h"
						},
					]
				}
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "30d"
					downsampling_1h: "60d"
				}
				client: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
				app: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
			}
		}
	}
	oaftdnzzmubkjwdy: {
		parent_zone_name: "ocb-psunvwhpwjejrxpb"
		provider: domain_name: "OCB0000000"
	}
	zzljkemefdztudpy: {
		parent_zone_name: "ocb-psunvwhpwjejrxpb"
		provider: domain_name: "OCB0000000"
	}
	scgpmkkeeedhhbiq: {
		parent_zone_name: "ocb-psunvwhpwjejrxpb"
		provider: domain_name: "OCB0000000"
	}
	wlcgbsrmprcbmgma: {
		parent_zone_name: "ocb-psunvwhpwjejrxpb"
		provider: domain_name: "OCB0000000"
	}
	"ocb-aoahobmpzsqohsjw": {
		parent_zone_name: "infra-zsgqzvbsvqufttlk"
		monitoring: {
			logs: {
				comnet: {
					retention: "15d"
					ingester_schema_config: [
						{
							date:    "2018-04-15"
							version: "v9"
							period:  "0h"
						},
						{
							date:    "2020-03-26"
							version: "v11"
							period:  "24h"
						},
					]
				}
				client: {
					retention: "30d"
					ingester_schema_config: [
						{
							date:    "2020-03-23"
							version: "v11"
							period:  "24h"
						},
					]
				}
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
				client: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
				app: retention: {
					raw:             "15d"
					downsampling_5m: "15d"
					downsampling_1h: "15d"
				}
			}
		}
	}
	"ocb-vgxfkcrhbhbemtun": {
		parent_zone_name: "infra-zsgqzvbsvqufttlk"
		monitoring: {
			logs: {
				comnet: {
					retention: "60d"
					ingester_schema_config: [
						{
							date:    "2021-01-25"
							version: "v11"
							period:  "24h"
						},
					]
				}
				client: {
					retention: "30d"
					ingester_schema_config: [
						{
							date:    "2021-01-25"
							version: "v11"
							period:  "24h"
						},
					]
				}
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
				client: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "190d"
				}
				app: retention: {
					raw:             "15d"
					downsampling_5m: "30d"
					downsampling_1h: "60d"
				}
			}
		}
	}

	mjgymrtsrufltfdo: {
		parent_zone_name: "ocb-vgxfkcrhbhbemtun"
		provider: domain_name: "OCB0000000"
	}
	"ocb-zymbygzzytlalgvl": {
		parent_zone_name: "infra-zsgqzvbsvqufttlk"
		monitoring: {
			logs: {
				comnet: {
					retention: "30d"
					ingester_schema_config: [
						{
							date:    "2020-03-19"
							version: "v11"
							period:  "24h"
						},
					]
				}
				client: {
					retention: "30d"
					ingester_schema_config: [
						{
							date:    "2020-03-19"
							version: "v11"
							period:  "24h"
						},
					]
				}
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
				client: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
				app: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
			}
		}
	}
	ipkmllvrrijnkfib: {
		parent_zone_name: "ocb-zymbygzzytlalgvl"
		provider: domain_name: "OCB0000000"
	}
	"ipkmllvrrijnkfib-stg": {
		parent_zone_name: "ocb-zymbygzzytlalgvl"
		provider: domain_name: "OCB0000000"
	}
	"ocb-pfpgmbnkryqrbzoe": {
		parent_zone_name: "infra-zsgqzvbsvqufttlk"
		monitoring: {
			logs: {
				comnet: {
					retention: "15d"
					ingester_schema_config: [
						{
							date:    "2018-04-15"
							version: "v9"
							period:  "0h"
						},
						{
							date:    "2020-03-26"
							version: "v11"
							period:  "24h"
						},
					]
				}
				client: {
					retention: "30d"
					ingester_schema_config: [
						{
							date:    "2020-04-02"
							version: "v11"
							period:  "24h"
						},
					]
				}
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
				client: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
				app: retention: {
					raw:             "15d"
					downsampling_5m: "15d"
					downsampling_1h: "15d"
				}
			}
		}
	}
	ma: {
		parent_zone_name: "ocb-pfpgmbnkryqrbzoe"
		provider: domain_name: "OCB0000000"
	}
	lccfnhgxtrizgrtl: {
		parent_zone_name: "ocb-pfpgmbnkryqrbzoe"
		provider: domain_name: "OCB0000000"
	}
	lccfnhgxtrizgrtldev: {
		parent_zone_name: "ocb-pfpgmbnkryqrbzoe"
		provider: domain_name: "OCB0000000"
	}
	ps: {
		parent_zone_name: "ocb-pfpgmbnkryqrbzoe"
		provider: domain_name: "OCB0000000"
	}
	qjkgtqjnnkffmqxb: {
		parent_zone_name: "ocb-pfpgmbnkryqrbzoe"
		provider: domain_name: "OCB0000000"
	}
	"ocb-pfpgmbnkryqrbzoeeg": {
		parent_zone_name: "infra-zsgqzvbsvqufttlk"
		monitoring: {
			logs: {
				comnet: {
					retention: "15d"
					ingester_schema_config: [
						{
							date:    "2020-04-09"
							version: "v11"
							period:  "24h"
						},
					]
				}
				client: {
					retention: "15d"
					ingester_schema_config: [
						{
							date:    "2020-06-08"
							version: "v11"
							period:  "24h"
						},
					]
				}
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
				client: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
				app: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
			}
		}
	}
	slbcrinxgodkifok: {
		parent_zone_name: "ocb-pfpgmbnkryqrbzoeeg"
		provider: domain_name: "OCB0000000"
	}
	"ocb-ilpybubiybhtluxw": {
		parent_zone_name: "infra-zwtkxvyalrulrfjt"
		monitoring: {
			logs: {
				comnet: {
					retention: "15d"
					ingester_schema_config: [
						{
							date:    "2020-05-07"
							version: "v11"
							period:  "24h"
						},
					]
				}
				client: {
					retention: "15d"
					ingester_schema_config: [
						{
							date:    "2020-05-07"
							version: "v11"
							period:  "24h"
						},
					]
				}
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
				client: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
				app: retention: {
					raw:             "15d"
					downsampling_5m: "15d"
					downsampling_1h: "15d"
				}
			}
		}
	}
	"ocb-hzgitwdojgogblpm": {
		parent_zone_name: "infra-zwtkxvyalrulrfjt"
		provider: {
			aws_accounts["comnet_ocb-hzgitwdojgogblpm"]
			region: "eu-west-3"
		}
		monitoring: {
			logs: {
				comnet: {
					retention: "15d"
					ingester_schema_config: [
						{
							date:    "2020-12-14"
							version: "v11"
							period:  "24h"
						},
					]
				}
				client: {
					retention: "15d"
					ingester_schema_config: [
						{
							date:    "2020-12-14"
							version: "v11"
							period:  "24h"
						},
					]
				}
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
				client: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
				app: retention: {
					raw:             "15d"
					downsampling_5m: "15d"
					downsampling_1h: "15d"
				}
			}
		}
	}
	"ocb-lwwscgigvcjwzflo": {
		parent_zone_name: "infra-zwtkxvyalrulrfjt"
		monitoring: {
			logs: {
				comnet: {
					retention: "15d"
					ingester_schema_config: [
						{
							date:    "2020-12-28"
							version: "v11"
							period:  "24h"
						},
					]
				}
				client: {
					retention: "15d"
					ingester_schema_config: [
						{
							date:    "2020-12-28"
							version: "v11"
							period:  "24h"
						},
					]
				}
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
				client: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
				app: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
			}
		}
	}
	"ocb-qpdtojgiovptnsqa": {
		parent_zone_name: "infra-zwtkxvyalrulrfjt"
		monitoring: {
			logs: {
				comnet: {
					retention: "15d"
					ingester_schema_config: [
						{
							date:    "2020-01-20"
							version: "v11"
							period:  "24h"
						},
					]
				}
				client: {
					retention: "15d"
					ingester_schema_config: [
						{
							date:    "2020-01-20"
							version: "v11"
							period:  "24h"
						},
					]
				}
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
				client: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
				app: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
			}
		}
	}
	"ocb-brxvogdhrnvxazrp": {
		parent_zone_name: "infra-zwtkxvyalrulrfjt"
		monitoring: {
			logs: {
				comnet: {
					retention: "15d"
					ingester_schema_config: [
						{
							date:    "2021-01-19"
							version: "v11"
							period:  "24h"
						},
					]
				}
				client: {
					retention: "15d"
					ingester_schema_config: [
						{
							date:    "2021-01-19"
							version: "v11"
							period:  "24h"
						},
					]
				}
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
				client: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
				app: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
			}
		}
	}
	eerryhrhvgbduosx: {
		parent_zone_name: "ocb-ilpybubiybhtluxw"
		provider:         zones[parent_zone_name].provider
	}
	unepmqybzvtwmyjx: {
		parent_zone_name: "ocb-ilpybubiybhtluxw"
		provider:         zones[parent_zone_name].provider
	}
	hszqlstppgwrbexx: {
		parent_zone_name: "ocb-ilpybubiybhtluxw"
		provider:         zones[parent_zone_name].provider
	}
	qvhuuynllrunnger: {
		parent_zone_name: "ocb-ilpybubiybhtluxw"
		provider: {
			aws_accounts.comnet_qvhuuynllrunnger
			region: "eu-west-3"
		}
	}
	ttvvzubrxywbjxob: {
		parent_zone_name: "ocb-lwwscgigvcjwzflo"
		provider:         zones[parent_zone_name].provider
	}
	"ocb-oalxziquintsqhht": {
		parent_zone_name: "infra-zwtkxvyalrulrfjt"
		monitoring: {
			logs: {
				comnet: {
					retention: "7d"
					ingester_schema_config: [
						{
							date:    "2020-03-09"
							version: "v11"
							period:  "24h"
						},
					]
				}
				client: {
					retention: "7d"
					ingester_schema_config: [
						{
							date:    "2020-03-09"
							version: "v11"
							period:  "24h"
						},
					]
				}
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
				client: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
				app: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
			}
		}
	}
	xladugdwqeqdipbl: {
		parent_zone_name: "ocb-oalxziquintsqhht"
		provider:         zones[parent_zone_name].provider
	}
	gnjpiwaumwbisbuw: {
		parent_zone_name: "ocb-oalxziquintsqhht"
		provider:         zones[parent_zone_name].provider
	}
	keayeqshiigjuegy: {
		parent_zone_name: "ocb-oalxziquintsqhht"
		provider: {
			aws_accounts.comnet_keayeqshiigjuegy
			region: "eu-west-3"
		}
	}
	"ocb-pvypwkspvtelreit": {
		parent_zone_name: "infra-zsgqzvbsvqufttlk"
		monitoring: {
			logs: {
				comnet: {
					retention: "60d"
					ingester_schema_config: [
						{
							date:    "2020-10-11"
							version: "v11"
							period:  "24h"
						},
					]
				}
				client: {
					retention: "30d"
					ingester_schema_config: [
						{
							date:    "2020-10-11"
							version: "v11"
							period:  "24h"
						},
					]
				}
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
				client: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
				app: retention: {
					raw:             "15d"
					downsampling_5m: "30d"
					downsampling_1h: "30d"
				}
			}
		}
	}
	"ocb-vfziogrqdglgqivh": {
		parent_zone_name: "infra-zsgqzvbsvqufttlk"
		provider: domain_name: "OCB0000000"
		monitoring: {
			logs: {
				comnet: {
					retention: "60d"
					ingester_schema_config: [
						{
							date:    "2021-02-22"
							version: "v11"
							period:  "24h"
						},
					]
				}
				client: {
					retention: "30d"
					ingester_schema_config: [
						{
							date:    "2021-02-22"
							version: "v11"
							period:  "24h"
						},
					]
				}
			}
			metrics: {
				comnet: retention: {
					raw:             "15d"
					downsampling_5m: "92d"
					downsampling_1h: "366d"
				}
				client: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
				app: retention: {
					raw:             "8d"
					downsampling_5m: "15d"
					downsampling_1h: "31d"
				}
			}
		}
	}
	"snrvfxuzlorkchin": {
		parent_zone_name: "ocb-vfziogrqdglgqivh"
		provider: domain_name: "OCB0000000"
	}
}
