package ci

import (
	z "comnet.io/zones"
)

#NixTaskConfig: {
	platform: "linux"
	image_resource: {
		type: "registry-image"
		source: {
			repository: "((global-docker-registry.url))/nix"
			tag:        "2.3.6"
			username:   "((global-docker-registry.username))"
			password:   "((global-docker-registry.password))"
		}
	}
	container_limits: memory: *1e9 | int
	run: {
		path: *"nix-shell" | string
		args: [...string]
		dir: *"." | string
	}
	...
}

#RepoURL: "((git-ipkmllvrrijnkfib.url))/comnet/terraform/envs-ng.git"

#GitResource: {
	name: *"envs-ng" | string
	type: "git"
	icon: "git"
	source: {
		uri:      *#RepoURL | string
		branch:   *"master" | string
		username: "((git-ipkmllvrrijnkfib.username))"
		password: "((git-ipkmllvrrijnkfib.token))"
	}
}

#MRResource: {
	name:        *"envs-ng-mr" | string
	type:        "merge-request"
	icon:        "source-pull"
	check_every: *"15s" | string
	source: {
		uri:           #RepoURL
		private_token: "((git-ipkmllvrrijnkfib.token))"
		...
	}
}

pipelines: [Name=string]: name: Name

infra_zone: *"infra-zwtkxvyalrulrfjt" | =~"^infra-" @tag(infra_zone)
line:       z.zones[infra_zone].metadata.line
