package trackbone

import (
	"text/template"
	"encoding/json"
	"encoding/yaml"
	"strings"
	"time"
)

// Options for action scripts
options: {
	// When false action scripts must not prompt the user
	interactive: *true | false @tag(interactive,type=bool)
	// Indicate that the action script should not output color escape codes
	no_color: *false | true @tag(no_color,type=bool)
	// Indicate that the plan action return some error code when a diff is found
	detailed_exitcode: *false | true @tag(detailed_exitcode,type=bool)
	// Setup some directory where the action can output or read files
	output_dir: *"" | string @tag(output_dir)
}

let Options = options

#VaultSource: {
	name:        string
	scheme:      *"https" | "http"
	hostname:    *"cjppmetyaderslgo" | string
	zone_name:   string
	domain_name: string
	url:         *"\(scheme)://\(hostname).\(zone_name).\(domain_name)" | string
}

#VaultCreds: {
	source:      string
	secret_path: string
}

#LocalBackend: {
	type: "local"
	params: {}
	backend_config: {
		terraform: backend: local: {}
	}
}

#S3Backend: {
	type: "s3"
	params: {
		creds:           #VaultCreds
		bucket:          string
		key:             string
		region:          string
		dynamodb_table?: string
	}
	backend_config: {
		terraform: backend: s3: {
			bucket:          params.bucket
			key:             params.key
			region:          params.region
			dynamodb_table?: string
			if params.dynamodb_table != _|_ {
				dynamodb_table: params.dynamodb_table
			}
		}
	}
}

#VaultProvider: {
	zone_name: string
	creds:     #VaultCreds
}

#K8SProvider: {
	zone_name: string
	creds:     #VaultCreds
}

#Source: {
	type:  string
	path?: string
}

#GitSource: {
	#Source
	type: "git"
	url:  string

	{branch: string, sha?: string} | {tag: string}

	// Initialize git submodules
	submodules: *false | bool
}

#LocalSource: {
	#Source
	type:    "local"
	basedir: string
}

#RunActions: {
	options: {
		output_dir:        *"" | string
		interactive:       Options.interactive
		no_color:          Options.no_color
		detailed_exitcode: Options.detailed_exitcode
	}
	actions: {
		pre_plan?:     string
		plan:          string
		post_plan?:    string
		pre_apply?:    string
		apply:         string
		post_apply?:   string
		plan_destroy:  string
		pre_destroy?:  string
		destroy:       string
		post_destroy?: string
	}
}

#File: {
	name:       string
	path:       *"" | string
	executable: *false | bool
	content:    string
}

#JSONFile: {
	#File
	data: {...}
	content: json.Marshal(data)
}

#YAMLFile: {
	#File
	data: {...}
	content: yaml.Marshal(data)
}

#Env: {
	EnvName=name: string
	configurations: [ConfigName=string]: #AnyConfig & {
		id:   "\(EnvName)/\(ConfigName)"
		name: *ConfigName | string
		if Options.output_dir != "" {
			run: options: output_dir: "\(Options.output_dir)/\(ConfigName)/\(EnvName)"
		}
	}
	...
}

#ConfigID: string

// Keep in sync with #Config
#AnyConfig: {
	id:   #ConfigID
	name: string
	type: string
	secrets: [SourceName=string]: #VaultSource & {
		name: SourceName
	}
	providers: {
		cjppmetyaderslgo?: [string]:      #VaultProvider
		kubernetes?: [string]: #K8SProvider
	}
	depends_on: [...#ConfigID]
	source: #GitSource | #LocalSource
	run:    #RunActions
	// FIXME: increase eval time too much
	// files: [string]: #File | #JSONFile | #YAMLFile
	files: [string]: #File
	files: [FileName=string]: {name: FileName}
	env_vars: [string]: string | int | bool
	...
}

#Config: {
	id:   #ConfigID
	name: string
	type: string
	secrets: [SourceName=string]: #VaultSource & {
		name: SourceName
	}
	providers: {
		cjppmetyaderslgo?: [string]:      #VaultProvider
		kubernetes?: [string]: #K8SProvider
	}
	depends_on: [...#ConfigID]
	source: #GitSource | #LocalSource
	run:    #RunActions
	// FIXME: increase eval time too much
	// files: [string]: #File | #JSONFile | #YAMLFile
	files: [string]: #File
	files: [FileName=string]: {name: FileName}
	env_vars: [string]: string | int | bool
	files: "plan.sh": {
		executable: true
		let Actions = strings.Join([
			if run.actions.pre_plan != _|_ {run.actions.pre_plan},
			run.actions.plan,
			if run.actions.post_plan != _|_ {run.actions.post_plan},
		], "\n")
		content: """
			#!/usr/bin/env bash
			set -euo pipefail
			\(Actions)
			"""
	}
	files: "apply.sh": {
		executable: true
		let Actions = strings.Join([
			if run.actions.pre_apply != _|_ {run.actions.pre_apply},
			run.actions.apply,
			if run.actions.post_apply != _|_ {run.actions.post_apply},
		], "\n")
		content: """
			#!/usr/bin/env bash
			set -euo pipefail
			\(Actions)
			"""
	}
	files: "plan_destroy.sh": {
		let Actions = strings.Join([
			if run.actions.pre_plan != _|_ {run.actions.pre_plan},
			run.actions.plan_destroy,
			if run.actions.post_plan != _|_ {run.actions.post_plan},
		], "\n")
		executable: true
		content:    """
			#!/usr/bin/env bash
			set -euo pipefail
			\(Actions)
			"""
	}
	files: "destroy.sh": {
		let Actions = strings.Join([
			if run.actions.pre_destroy != _|_ {run.actions.pre_destroy},
			run.actions.destroy,
			if run.actions.post_destroy != _|_ {run.actions.post_destroy},
		], "\n")
		executable: true
		content:    """
			#!/usr/bin/env bash
			set -euo pipefail
			\(Actions)
			"""
	}
}

#TFConfig: {
	#Config
	type:    "terraform"
	backend: #S3Backend | #LocalBackend
	tfvars: {...}
	files: ".plan.md.tpl": {
		content: """
			{{- if gt .Stats.Total 0 }}
			**Result**: {{.Stats.Added}} to add, {{.Stats.Changed}} to change, {{.Stats.Destroyed}} to destroy

			| Action | Resource |
			|--------|----------|
			{{- range $rc := .ResourceChanges -}}
			{{if ne $rc.Change.ActionString "no-op"}}
			| {{$rc.Change.ActionString}} | {{$rc.Address}} |
			{{- end}}
			{{- end}}
			{{- else}}
			**Result**: no changes
			{{- end}}
			"""
	}
	files: "terraform.tfvars.json": {
		content: json.Marshal(tfvars)
	}
	run: {
		options: _
		actions: plan:         template.Execute("""
			terraform init {{ if .no_color }}-no-color{{ end }}
			{{ if .output_dir }}mkdir -p {{ .output_dir }}{{ end }}
			terraform plan {{ if not .interactive }}-input=false{{ end }} {{ if .no_color }}-no-color{{ end }} {{ if .detailed_exitcode }}-detailed-exitcode -lock=false{{ end }} {{ if .output_dir }}-out={{ .output_dir }}/plan.out{{ end }}
			{{- if .output_dir }}
			qvhuuynllrunnger "Exporting plan to json..."
			terraform show {{ if .no_color }}-no-color{{ end }} -json {{ .output_dir }}/plan.out > {{ .output_dir }}/plan.json
			terraform-plan-tpl {{ .output_dir }}/plan.json ./.plan.md.tpl > {{ .output_dir }}/plan.md
			{{- end }}
			""", options)
		actions: apply:        template.Execute("""
			terraform init {{ if .no_color }}-no-color{{ end }}
			terraform apply {{ if not .interactive }}-input=false -auto-approve{{ end }} {{ if .no_color }}-no-color{{ end }} {{ if .output_dir }}{{ .output_dir }}/plan.out{{ end }}
			""", options)
		actions: plan_destroy: template.Execute("""
			terraform init {{ if .no_color }}-no-color{{ end }}
			{{ if .output_dir }}mkdir -p {{ .output_dir }}{{ end }}
			terraform plan -destroy {{ if not .interactive }}-input=false{{ end }} {{ if .no_color }}-no-color{{ end }} {{ if .detailed_exitcode }}-detailed-exitcode -lock=false{{ end }} {{ if .output_dir }}-out={{ .output_dir }}/plan.out{{ end }}
			{{- if .output_dir }}
			qvhuuynllrunnger "Exporting plan to json..."
			terraform show {{ if .no_color }}-no-color{{ end }} -json {{ .output_dir }}/plan.out > {{ .output_dir }}/plan.json
			terraform-plan-tpl {{ .output_dir }}/plan.json ./.plan.md.tpl > {{ .output_dir }}/plan.md
			{{- end }}
			""", options)
		actions: destroy:      template.Execute("""
			terraform init {{ if .no_color }}-no-color{{ end }}
			terraform destroy {{ if not .interactive }}-input=false -auto-approve{{ end }} {{ if .no_color }}-no-color{{ end }}
			""", options)
	}
}

#HelmConfig: {
	#Config
	type: "helm"
	helm: {
		// Install chart in namespace
		namespace: string
		// Helm release name
		release_name: string
		// Helm values
		values: {...}
		// Path to the helm chart. Relative to `source.path`
		path: string
		// Additional arguments to pass to helm and helm diff
		extra_args: [...string]
		// Whether helm diff should diff helm hooks
		diff_hooks: *true | false
		// Rollback when install or upgrade fail
		atomic: *true | false
		// Wait for all resources to be ready after install or upgrade
		wait: *true | false
		// How long to wait for resources to be ready
		wait_timeout?: time.Duration
	}
	files: "values.yaml": {
		content: yaml.Marshal(helm.values)
	}
	files: ".plan.md.tpl": {
		content: """
			{{- if gt (len .) 0 }}
			| Action | Kind | Name |
			|--------|------|------|
			{{- range $idx, $entry := . }}
			|{{ $entry.Change }}|{{ $entry.Kind}}|{{ $entry.Name }}|
			{{- end }}
			{{- else }}
			**Result**: no changes
			{{- end }}
			"""
	}
	files: ".plan_destroy.md.tpl": {
		content: """
			|Action|Kind|Name|
			|---|---|---|
			{{range .items}}{{printf "| DELETE | %s | %s |\\n" .kind .metadata.name}}{{end}}
			"""
	}
	env_vars: {
		HELM_CACHE_HOME:        "./.helm/cache"
		HELM_CONFIG_HOME:       "./.helm/config"
		HELM_DATA_HOME:         "./.helm/data"
		HELM_REGISTRY_CONFIG:   "./.helm/config/registry.json"
		HELM_REPOSITORY_CACHE:  "./.helm/cache/repository"
		HELM_REPOSITORY_CONFIG: "./.helm/config/repositories.yaml"
	}
	run: {
		let Args = strings.Join([
			for a in helm.extra_args {a},
			"-f", "values.yaml",
		], " ")
		let PlanArgs = strings.Join([
			if !helm.diff_hooks {
				"--no-hooks"
			},
		], " ")
		let ApplyArgs = strings.Join([
			if helm.atomic {"--atomic"},
			if helm.wait {"--wait"},
			if helm.wait_timeout != _|_ {"--timeout"},
			if helm.wait_timeout != _|_ {helm.wait_timeout},
		], " ")
		options: _
		actions: plan:         template.Execute("""
			helm dependency update "\(helm.path)"
			helm diff upgrade {{ if .no_color }}--no-color{{ end }} {{ if .detailed_exitcode }}--detailed-exitcode{{ end }} --install --namespace "\(helm.namespace)" \(PlanArgs) \(Args) "\(helm.release_name)" "\(helm.path)"
			{{- if .output_dir }}
			export HELM_DIFF_TPL=./.plan.md.tpl
			helm diff upgrade --output template {{ if .no_color }}--no-color{{ end }} {{ if .detailed_exitcode }}--detailed-exitcode{{ end }} --install --namespace "\(helm.namespace)" \(PlanArgs) \(Args) "\(helm.release_name)" "\(helm.path)" > {{ .output_dir }}/plan.md
			{{- end }}
			""", options)
		actions: apply:        template.Execute("""
			helm dependency update "\(helm.path)"
			{{- if .interactive }}
			helmdiff="$(helm diff upgrade {{ if .no_color }}--no-color{{ end }} --install --namespace "\(helm.namespace)" \(PlanArgs) \(Args) "\(helm.release_name)" "\(helm.path)")"
			if [[ -z "$helmdiff" ]]; then
				qvhuuynllrunnger "No change."
				exit 0
			fi
			qvhuuynllrunnger "$helmdiff"
			cat <<EOF

			Do you want to perform this diff?
			  Helm will perform the actions described above.
			  Only 'yes' will be adcopcpjuuzvxnflopted to approve.

			EOF
			qvhuuynllrunnger -n '  Enter a value: '
			read answser
			qvhuuynllrunnger
			if [[ "$answser" != "yes" ]]; then
				qvhuuynllrunnger -e "Apply cancelled."
				exit 1
			fi
			{{- end }}
			helm upgrade --install --create-namespace --namespace "\(helm.namespace)" \(ApplyArgs) \(Args) "\(helm.release_name)" "\(helm.path)"
			""", options)
		actions: plan_destroy: template.Execute("""
			{{- if .output_dir }}
			helm get manifest -n "\(helm.namespace)" "\(helm.release_name)" | kubectl get -n "\(helm.namespace)" -f - -o go-template-file --template=./.plan_destroy.md.tpl > {{ .output_dir }}/plan.md
			{{- end }}
			""", options)
		actions: destroy:      template.Execute("""
			helm uninstall --namespace "\(helm.namespace)" "\(helm.release_name)"
			""", options)
	}
}
