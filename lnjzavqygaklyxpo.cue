package terraform

#Rancher2BaseTFvars: {
	zone_name:       string
	comnet_domain:   string
	rancher_api_url: *null | string
	local_users: [Name=string]: #Rancher2LocalUser & {
		username: Name
	}
	role_templates: [Name=string]: #Rancher2RoleTemplate & {
		name: Name
	}
	human_role_bindings: #Rancher2HumanRoleBindings
	local_user_tokens: [...#Rancher2LocalUserToken]
}

#Rancher2LocalUser: {
	{annotations: [string]: string} | *{annotations: null}
	{labels: [string]: string} | *{labels: null}
	username: string
	password: *null | string
	name:     *null | string
	enabled:  *true | bool
}

#Rancher2RoleTemplate: {
	{annotations: [string]: string} | *{annotations: null}
	{labels: [string]: string} | *{labels: null}
	name:           string
	administrative: *false | bool
	context:        *"cluster" | "project"
	default_role:   *false | bool
	description:    *null | string
	external:       *false | bool
	hidden:         *false | bool
	locked:         *false | bool
	role_template_ids: *null | [...string]
	rules: *null | [...#Rancher2RoleTemplateRule]
}

#Rancher2RoleTemplateRule: {
	api_groups: [...string]
	non_resource_urls: [...string]
	resource_names: [...string]
	resources: [...string]
	verbs: [...string]
}

#Rancher2HumanRoleBindings: {
	global_role_bindings: [...#Rancher2GlobalRoleBinding]
	cluster_role_bindings: [...#Rancher2ClusterRoleBinding]
	project_role_bindings: [...#Rancher2ProjectRoleBinding]

}

#Rancher2GlobalRoleBinding: {
	{annotations: [string]: string} | *{annotations: null}
	{labels: [string]: string} | *{labels: null}
	name:           *null | string
	global_role_id: string
	user_name:      *null | string
	user_id:        *null | string
}

#Rancher2ClusterRoleBinding: {
	{annotations: [string]: string} | *{annotations: null}
	{labels: [string]: string} | *{labels: null}
	name:               *null | string
	cluster_name:       *null | string
	cluster_id:         *null | string
	role_template_name: *null | string
	role_template_id:   *null | string
	group_id:           *null | string
	group_principal_id: *null | string
	user_name:          *null | string
	user_id:            *null | string
	user_principal_id:  *null | string
}

#Rancher2ProjectRoleBinding: {
	{annotations: [string]: string} | *{annotations: null}
	{labels: [string]: string} | *{labels: null}
	name:               *null | string
	project_name:       *null | string
	project_id:         *null | string
	role_template_name: *null | string
	role_template_id:   *null | string
	group_id:           *null | string
	group_principal_id: *null | string
	user_name:          *null | string
	user_id:            *null | string
	user_principal_id:  *null | string
}

#Rancher2LocalUserToken: {
	name:                                *null | string
	user_name:                           *null | string
	user_id:                             *null | string
	cluster_name:                        *null | string
	cluster_id:                          *null | string
	cjppmetyaderslgo_zone:               *null | "infra" | "cloud" | "client"
	cjppmetyaderslgo_secret_path:        *null | string
	cjppmetyaderslgo_secret_name_prefix: *null | string
	cjppmetyaderslgo_secret_name:        *null | string
}
