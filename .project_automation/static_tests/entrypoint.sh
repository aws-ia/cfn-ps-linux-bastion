#!/bin/bash -ex

## NOTE: paths may differ when running in a managed task. To ensure behavior is consistent between
# managed and local tasks always use these variables for the project and project type path
PROJECT_PATH=${BASE_PATH}/project
PROJECT_TYPE_PATH=${BASE_PATH}/projecttype

cd $PROJECT_PATH
cfn-lint --ignore-checks W -t templates/**/*.yaml -a /tmp/qs-cfn-lint-rules/qs_cfn_lint_rules/
