package test

import (
	tb "comnet.io/trackbone"
)

bootstrap: *false | true @tag(bootstrap,type=bool)

configsPath: string @tag(configsPath)

#TFConfig: tb.#TFConfig & {
	backend: *tb.#LocalBackend | tb.#S3Backend
}

#EnvTest: tb.#Env & {
	configurations: {
		config_no_shell:    #TFConfig
		config_null:        #TFConfig
		config_apply_error: #TFConfig & {
			depends_on: [
				config_null.id,
			]
		}
		config_error: #TFConfig & {
			depends_on: [
				config_apply_error.id,
			]
		}
		config_with_vars: #TFConfig & {
			depends_on: [
				config_error.id,
			]
		}
		config_helm: tb.#HelmConfig & {
			helm: {
				namespace:    "test"
				release_name: "test"
				path:         "./test-chart"
				extra_args: ["--dry-run"]
				values: {
					foo: "hello"
					bar: "world"
				}
				wait_timeout: "10m"
			}
		}
	}
}

envs: [EnvName=string]: #EnvTest & {
	name: EnvName
}

envs: [string]: configurations: [ConfigName=string]: {
	source: tb.#LocalSource & {
		basedir: configsPath
		path:    "configurations/\(ConfigName)"
	}
}

envs: "ocb-x": {
	configurations: config_with_vars: {
		env_vars: {
			TF_VAR_str:  "bar"
			TF_VAR_int:  42
			TF_VAR_bool: true
		}
		tfvars: {
			foo: "bar"
			bar: "foo"
		}
		files: "test.txt": tb.#File & {
			path:    "demo"
			content: "Hello World"
		}
	}
}

envs: "ocb-y": configurations: {
	config_null: {
		backend: tb.#S3Backend & {
			params: {
				creds: source:      "foo"
				creds: secret_path: "foo"
				bucket: "foo"
				key:    "bar"
				region: "xxx"
			}
		}
	}
	config_error: {
		backend: tb.#S3Backend & {
			params: {
				creds: source:      "foo"
				creds: secret_path: "foo"
				bucket:         "foo"
				key:            "bar"
				region:         "xxx"
				dynamodb_table: "foo"
			}
		}
	}
}
