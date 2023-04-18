#!/bin/bash -ex

## NOTE: paths may differ when running in a managed task. To ensure behavior is consistent between
# managed and local tasks always use these variables for the project and project type path
PROJECT_PATH=${BASE_PATH}/project
PROJECT_TYPE_PATH=${BASE_PATH}/projecttype

##----------------------------------------------------
## Download taskcat overrides from AWS Secrets Manager
## ---------------------------------------------------
## Create a 'secret' of type plaintext in AWS Secrets Manager
## and add taskcat override file contents to it.
## Provide secret name to 'secret_name' parameter below and
## the AWS region where you secret is stored to 'aws_region'.

# set defaults
secret_name=$(cat .taskcat.yml | yq -r '.project|.name')
secret_name=${secret_name}-override
secret_region="us-east-1"
# retrieve the secret value as a JSON string
overrides=$(aws secretsmanager get-secret-value --secret-id $secret_name --query SecretString --output text --region $secret_region)
# convert the JSON string to YAML and save it to a file
echo "$overrides" > .taskcat_overrides.yml
##----------------------------------------------------

# set taskcat general config
cat << EOF > ~/.taskcat.yml
general:
  s3_regional_buckets: true
EOF

# Run taskcat tests
taskcat test run