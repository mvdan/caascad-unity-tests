package terraform

envs: [string]: {
	zone: _
	configurations: ["fxhrnkeurlewsyfn"]: {
		source: *(#TerraformLib & {
			tag: "fxhrnkeurlewsyfn-v1.0.0"
		}) | #TerraformLib | #LocalSource
		source: path: "configurations/fxhrnkeurlewsyfn"
		if !bootstrap {
			providers: kubernetes: "\(zone.name)": _
		}
		if bootstrap {
			providers: cjppmetyaderslgo: "\(zone.infra_zone_name)": _
			run: actions: {
				pre_plan:  """
					kswitch \(zone.name)
					function cleanup() {
						kswitch -k
					}
					trap cleanup EXIT INT TERM
					"""
				pre_apply: pre_plan
			}
		}
		tfvars: #StorageClassesTfvars & {
			storage_classes: {
				"comnet-storage-standard": {
					if zone.provider.type == "fe" {
						allow_volume_expansion: true
						if configurations["dcopcpjuuzvxnflo"].tfvars.cluster_version =~ "^v1[.]13[.][a-zA-Z0-9_-]+$" {
							storage_provisioner: "flexvolume-huawei.com/fuxivol"
							parameters: {
								"kubernetes.io/description":    ""
								"kubernetes.io/hw:passthrough": "true"
								"kubernetes.io/storagetype":    "BS"
								"kubernetes.io/volumetype":     "SAS"
							}
							dynamic_parameters: [
								{
									storageclass: "sas"
									parameter:    "kubernetes.io/zone"
								},
							]
						}
						if configurations["dcopcpjuuzvxnflo"].tfvars.cluster_version !~ "^v1[.]13[.][a-zA-Z0-9_-]+$" {
							storage_provisioner: "everest-csi-provisioner"
							parameters: {
								"csi.storage.k8s.io/csi-driver-name": "disk.csi.everest.io"
								"csi.storage.k8s.io/fstype":          "ext4"
								"everest.io/disk-volume-type":        "SAS"
								"everest.io/passthrough":             "true"
							}
						}
					}
					if zone.provider.type == "aws" {
						storage_provisioner: "kubernetes.io/aws-ebs"
						parameters: {
							"fsType": "ext4"
							"type":   "gp2"
						}
					}
				}
				"comnet-storage-highperf": {
					if zone.provider.type == "fe" {
						allow_volume_expansion: true
						if configurations["dcopcpjuuzvxnflo"].tfvars.cluster_version =~ "^v1[.]13[.][a-zA-Z0-9_-]+$" {
							storage_provisioner: "flexvolume-huawei.com/fuxivol"
							parameters: {
								"kubernetes.io/description":    ""
								"kubernetes.io/hw:passthrough": "true"
								"kubernetes.io/storagetype":    "BS"
								"kubernetes.io/volumetype":     "SSD"
							}
							dynamic_parameters: [
								{
									storageclass: "ssd"
									parameter:    "kubernetes.io/zone"
								},
							]
						}
						if configurations["dcopcpjuuzvxnflo"].tfvars.cluster_version !~ "^v1[.]13[.][a-zA-Z0-9_-]+$" {
							storage_provisioner: "everest-csi-provisioner"
							parameters: {
								"csi.storage.k8s.io/csi-driver-name": "disk.csi.everest.io"
								"csi.storage.k8s.io/fstype":          "ext4"
								"everest.io/disk-volume-type":        "SSD"
								"everest.io/passthrough":             "true"
							}
						}
					}
					if zone.provider.type == "aws" {
						storage_provisioner: "kubernetes.io/aws-ebs"
						parameters: {
							"fsType":    "ext4"
							"type":      "io1"
							"iopsPerGB": "32"
						}
					}
				}
				"comnet-storage-throughput": {
					if zone.provider.type == "fe" {
						allow_volume_expansion: true
						if configurations["dcopcpjuuzvxnflo"].tfvars.cluster_version =~ "^v1[.]13[.][a-zA-Z0-9_-]+$" {
							storage_provisioner: "flexvolume-huawei.com/fuxinfs"
							parameters: {
								"kubernetes.io/adcopcpjuuzvxnflosslevel": "rw"
								"kubernetes.io/description":              ""
								"kubernetes.io/ispublic":                 "false"
								"kubernetes.io/shareproto":               "NFS"
								"kubernetes.io/storagetype":              "NFS"
							}
							dynamic_parameters: [
								{
									storageclass: "nfs-rw"
									parameter:    "kubernetes.io/adcopcpjuuzvxnflossto"
								},
								{
									storageclass: "nfs-rw"
									parameter:    "kubernetes.io/zone"
								},
							]

						}
						if configurations["dcopcpjuuzvxnflo"].tfvars.cluster_version !~ "^v1[.]13[.][a-zA-Z0-9_-]+$" {
							storage_provisioner: "everest-csi-provisioner"
							parameters: {
								"csi.storage.k8s.io/csi-driver-name":         "nas.csi.everest.io"
								"csi.storage.k8s.io/fstype":                  "nfs"
								"everest.io/share-adcopcpjuuzvxnfloss-level": "rw"
								"everest.io/share-is-public":                 "false"
							}
							dynamic_parameters: [
								{
									storageclass: "csi-nas"
									parameter:    "everest.io/share-adcopcpjuuzvxnfloss-to"
								},
								{
									storageclass: "csi-nas"
									parameter:    "everest.io/zone"
								},
							]
						}
					}
					if zone.provider.type == "aws" {
						storage_provisioner: "kubernetes.io/aws-ebs"
						parameters: {
							"fsType": "ext4"
							"type":   "st1"
						}
					}
				}
			}

		}
	}
}

#StorageClassesTfvars: {
	storage_classes: [StorageClassName=string]: {
		name: *StorageClassName | string
		annotations: [string]: string
		labels: [string]:      string
		parameters: [string]:  string
		dynamic_parameters: [...{
			storageclass:  string
			parameter:     string
			new_parameter: *parameter | string
		}]
		storage_provisioner:    string
		reclaim_policy:         *"Delete" | string
		volume_binding_mode:    *"WaitForFirstConsumer" | string
		allow_volume_expansion: *false | bool
		mount_options: [...string]
	}
}
