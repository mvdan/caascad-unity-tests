package terraform

import (
	"strings"
	"comnet.io/zones"
)

let Zones = zones.zones

ipam: {
	natgw: {
		"infra-zsgqzvbsvqufttlk": ["127.0.0.1/32"]
		"ocb-psunvwhpwjejrxpb": ["127.0.0.1/32"]
		"ocb-aoahobmpzsqohsjw": ["127.0.0.1/32"]
		"ocb-pfpgmbnkryqrbzoe": ["127.0.0.1/32"]
		"ocb-pfpgmbnkryqrbzoeeg": ["127.0.0.1/32"]
		"ocb-zymbygzzytlalgvl": ["127.0.0.1/32"]
		"ocb-kqhdbwhauaohdayi": ["127.0.0.1/32"]
		"ocb-pvypwkspvtelreit": ["127.0.0.1/32"]
		"ocb-vgxfkcrhbhbemtun": ["127.0.0.1/32"]
		"ocb-vfziogrqdglgqivh": ["127.0.0.1/32"]

		"infra-zwtkxvyalrulrfjt": ["127.0.0.1/32"]
		"ocb-oalxziquintsqhht": ["127.0.0.1/32"]
		"ocb-ilpybubiybhtluxw": ["127.0.0.1/32"]
		"ocb-hzgitwdojgogblpm": ["127.0.0.1/32", "127.0.0.1/32"]
		"ocb-lwwscgigvcjwzflo": ["127.0.0.1/32"]
		"ocb-qpdtojgiovptnsqa": ["127.0.0.1/32"]
		"ocb-brxvogdhrnvxazrp": ["127.0.0.1/32"]
		"ocb-test07": ["127.0.0.1/32"]
	}
	vpn: {
		comnet: "127.0.0.1/24"
	}
}

#Whitelist: {
	[=~"(TCP|UDP)/[0-9]+"]: {
		[string]: =~"^((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\\/(\\d|[1-2]\\d|3[0-2]))?,?)+$"
	}
}
envs: [string]: {
	zone:       _
	infra_zone: _
	configurations: ["rwuzkqovopspvomc"]: {
		source: *(#TerraformLib & {
			tag: "rwuzkqovopspvomc-v2.0.2"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/rwuzkqovopspvomc"
		providers: cjppmetyaderslgo: "\(infra_zone.name)": _
		tfvars: {
			zone_name:       zone.name
			domain_name:     zone.domain_name
			infra_zone_name: infra_zone.name
			whitelists: [string]: #Whitelist
			if (zone.type == "cloud") {
				whitelists: private: {
					"TCP/443": {
						vpn: ipam.vpn.comnet
						// Allow infra zone to reach cloud zone ingress
						"\(infra_zone_name)_natgw": strings.Join(ipam.natgw[infra_zone_name], ",")
						// Allow the zone itself
						if ipam.natgw[zone_name] != _|_ {
							"\(zone_name)_natgw": strings.Join(ipam.natgw[zone_name], ",")
						}
					}
					"TCP/80": private["TCP/443"]
					"TCP/2222": {
						// for concourse infra worker
						if ipam.natgw[zone_name] != _|_ {
							"\(zone_name)_natgw": strings.Join(ipam.natgw[zone_name], ",")
						}
					}
				}
			}
			if (zone.type == "infra") {
				// The NAT GW list of cloud zones of the current infra zone
				let CloudNATGWs = {
					for c in infra_zone.child_zone_names
					if ipam.natgw[c] != _|_ {
						"\(c)_natgw": strings.Join(ipam.natgw[c], ",")
					}
				}
				whitelists: private: {
					"TCP/443": {
						vpn: ipam.vpn.comnet
						// k8s docker pull on the infra docker registry (which is private)
						// rancher agent to ranger server
						"\(infra_zone_name)_natgw": strings.Join(ipam.natgw[infra_zone_name], ",")
						// Allow child cloud zones NAT GWs to reach the infra zone ingress:
						// * cjppmetyaderslgo transit
						// * tczfxjfecbzgxqeq IDP client
						CloudNATGWs
					}
					"TCP/80": private["TCP/443"]
					"TCP/22": {
						vpn: ipam.vpn.comnet
						// for gitea
						"\(infra_zone_name)_natgw": strings.Join(ipam.natgw[infra_zone_name], ",")
					}
					"TCP/2222": {
						// for concourse infra worker
						"\(infra_zone_name)_natgw": strings.Join(ipam.natgw[infra_zone_name], ",")
					}
				}
			}
		}
	}
}

envs: ["infra-zwtkxvyalrulrfjt"]: configurations: rwuzkqovopspvomc: tfvars: {
	whitelists: private: {
		// Allow infra-zsgqzvbsvqufttlk zones
		"TCP/443": "infra-zsgqzvbsvqufttlk_natgw": strings.Join(ipam.natgw["infra-zsgqzvbsvqufttlk"], ",")
		"TCP/443": {
			for c in Zones["infra-zsgqzvbsvqufttlk"].child_zone_names
			if ipam.natgw[c] != _|_ {
				"\(c)_natgw": strings.Join(ipam.natgw[c], ",")
			}
		}
		// FIXME: unknown IPs that were allowed in old envs
		"TCP/443": {
			unknown_0: "127.0.0.1"
			unknown_1: "127.0.0.1"
			unknown_2: "127.0.0.1"
			unknown_3: "127.0.0.1"
		}
	}
}

envs: ["infra-zsgqzvbsvqufttlk"]: configurations: rwuzkqovopspvomc: tfvars: {
	whitelists: private: {
		// Allow docker push from infra-zwtkxvyalrulrfjt to infra-zsgqzvbsvqufttlk registry
		"TCP/443": "infra-zwtkxvyalrulrfjt_natgw": strings.Join(ipam.natgw["infra-zwtkxvyalrulrfjt"], ",")
	}
}

envs: [=~"^(ipkmllvrrijnkfib|ipkmllvrrijnkfib-stg)$"]: configurations: rwuzkqovopspvomc: tfvars: {
	whitelists: private: {
		"TCP/443": {
			vpn: ipam.vpn.comnet
			// Allow tczfxjfecbzgxqeq infra to reach tczfxjfecbzgxqeq ipkmllvrrijnkfib
			"infra-zwtkxvyalrulrfjt_natgw": strings.Join(ipam.natgw["infra-zwtkxvyalrulrfjt"], ",")
			"infra-zsgqzvbsvqufttlk_natgw": strings.Join(ipam.natgw["infra-zsgqzvbsvqufttlk"], ",")
		}
		"TCP/80": private["TCP/443"]
	}
}

envs: ["ocb-vfziogrqdglgqivh"]: configurations: rwuzkqovopspvomc: tfvars: {
	whitelists: public: {
		"UDP/53": {
			fe_internals: "127.0.0.1/15"
		}
	}
}
