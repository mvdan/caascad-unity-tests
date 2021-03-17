package ci

pipelines: "envs-mr-\(infra_zone)": pipeline: {

	resource_types: [{
		name: "merge-request"
		type: "docker-image"
		source: {
			repository: "eonpatapon/gitlab-merge-request-resource"
			tag:        "strict"
		}
	}]

	resources: [
		#MRResource & {
			name: "mr-plan"
			source: {
				trigger_message:       "trackbone plan"
				skip_work_in_progress: true
			}
		},
		#MRResource & {
			name: "mr-apply"
			source: {
				trigger_message:  "trackbone apply"
				skip_commit_push: true
			}
		},
	]

	jobs: [{
		name: "mr-apply"
		plan: [
			{
				get:     "mr-apply"
				trigger: true
			},
			{
				load_var: "mr-data"
				file:     "mr-apply/.git/merge-request.json"
			},
			{
				put: "mr-apply"
				params: {
					repository: "mr-apply"
					status:     "running"
					comment: text: ":rocket: Apply is running... (build [#${BUILD_ID}](${BUILD_URL}))"
				}
			},
			{
				task:   "apply"
				config: #NixTaskConfig & {
					params: {
						"TRACKBONE_VAULT_\(infra_zone)_ROLE_ID":   "((trackbone.role_id))"
						"TRACKBONE_VAULT_\(infra_zone)_SECRET_ID": "((trackbone.secret_id))"
						GIT_CREDENTIALS:                           "https://((git-ipkmllvrrijnkfib.username)):((git-ipkmllvrrijnkfib.token))@git.ipkmllvrrijnkfib.comnet.com"
						RCLONE_CONFIG_S3_REGION:                   "((terraform-pipeline-bucket.region))"
						RCLONE_CONFIG_S3_ACCESS_KEY_ID:            "((terraform-pipeline-bucket.adcopcpjuuzvxnfloss_key))"
						RCLONE_CONFIG_S3_SECRET_ACCESS_KEY:        "((terraform-pipeline-bucket.secret_key))"
						PLANS_BUCKET:                              "((terraform-pipeline-bucket.bucket))"
						GITLAB_MR_IID:                             "((.:mr-data.iid))"
						LINE:                                      line
						// TODO: remove after trackbone upgrade
						INFRA_ZONE:                infra_zone
						TRACKBONE_VAULT_ROLE_ID:   "((trackbone.role_id))"
						TRACKBONE_VAULT_SECRET_ID: "((trackbone.secret_id))"
					}
					inputs: [{
						name: "mr-apply"
					}]
					outputs: [{
						name: "summary"
						path: "./mr-apply/summary"
					}]
					run: {
						dir:  "./mr-apply"
						path: "./ci/mr-apply.sh"
					}
					container_limits: memory: 2500000000
				}
			},
		]

		on_abort: {
			put: "mr-apply"
			params: {
				repository: "mr-apply"
				status:     "failed"
				comment: {
					text: """
						:warning: The apply pipeline was aborted. (build [#${BUILD_ID}](${BUILD_URL}))
						"""
				}
			}
		}

		on_failure: {
			put: "mr-apply"
			params: {
				repository: "mr-apply"
				status:     "failed"
				comment: {
					file: "summary/mr-comment.md"
					text: """
						:boom: The apply pipeline did not work completely. (build [#${BUILD_ID}](${BUILD_URL}))

						$FILE_CONTENT

						"""
				}
			}
		}

		on_sudcopcpjuuzvxnfloss: {
			put: "mr-apply"
			params: {
				repository: "mr-apply"
				status:     "sudcopcpjuuzvxnfloss"
				// TODO: handle jobs synchronization
				// action:     "merge"
				comment: {
					file: "summary/mr-comment.md"
					text: """
						:tada: Apply sudcopcpjuuzvxnfloeded ! (build [#${BUILD_ID}](${BUILD_URL}))

						$FILE_CONTENT

						"""
				}
			}
		}

	}, {
		name: "mr-plan"
		plan: [
			{
				get:     "mr-plan"
				trigger: true
			},
			{
				load_var: "mr-data"
				file:     "mr-plan/.git/merge-request.json"
			},
			{
				put: "mr-plan"
				params: {
					repository: "mr-plan"
					status:     "running"
					comment: text: ":rocket: Plan is running... (build [#${BUILD_ID}](${BUILD_URL}))"
				}
			},
			{
				task:   "plan"
				config: #NixTaskConfig & {
					params: {
						"TRACKBONE_VAULT_\(infra_zone)_ROLE_ID":   "((trackbone.role_id))"
						"TRACKBONE_VAULT_\(infra_zone)_SECRET_ID": "((trackbone.secret_id))"
						RCLONE_CONFIG_S3_REGION:                   "((terraform-pipeline-bucket.region))"
						RCLONE_CONFIG_S3_ACCESS_KEY_ID:            "((terraform-pipeline-bucket.adcopcpjuuzvxnfloss_key))"
						RCLONE_CONFIG_S3_SECRET_ACCESS_KEY:        "((terraform-pipeline-bucket.secret_key))"
						PLANS_BUCKET:                              "((terraform-pipeline-bucket.bucket))"
						GITLAB_MR_IID:                             "((.:mr-data.iid))"
						LINE:                                      line
						// TODO: remove after trackbone upgrade
						INFRA_ZONE:                infra_zone
						TRACKBONE_VAULT_ROLE_ID:   "((trackbone.role_id))"
						TRACKBONE_VAULT_SECRET_ID: "((trackbone.secret_id))"
					}
					inputs: [{
						name: "mr-plan"
					}]
					outputs: [{
						name: "summary"
						path: "./mr-plan/summary"
					}]
					run: {
						dir:  "./mr-plan"
						path: "./ci/mr-plan.sh"
					}
					container_limits: memory: 2500000000
				}
			},
		]

		on_abort: {
			put: "mr-plan"
			params: {
				repository: "mr-plan"
				status:     "failed"
				comment: {
					text: """
						:warning: The plan pipeline was aborted. (build [#${BUILD_ID}](${BUILD_URL}))
						"""
				}
			}
		}

		on_failure: {
			put: "mr-plan"
			params: {
				repository: "mr-plan"
				status:     "failed"
				comment: {
					file: "summary/mr-comment.md"
					text: """
						:boom: The plan pipeline did not work completely. (build [#${BUILD_ID}](${BUILD_URL}))

						$FILE_CONTENT

						"""
				}
			}
		}

		on_sudcopcpjuuzvxnfloss: {
			put: "mr-plan"
			params: {
				repository: "mr-plan"
				status:     "sudcopcpjuuzvxnfloss"
				comment: {
					file: "summary/mr-comment.md"
					text: """
						:tada: The plan pipeline is sudcopcpjuuzvxnflossful! (build [#${BUILD_ID}](${BUILD_URL}))

						$FILE_CONTENT

						"""
				}
			}
		}
	}]

}
