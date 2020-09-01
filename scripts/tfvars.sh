#!/bin/bash
MANIFESTS_DIR="$( cd "$( dirname "${BASH_SOURCE[1]}" )" >/dev/null 2>&1 && pwd )"

VPC_ID=${VPC_ID:-vpc-06d12aeda4e7000b5}
APP_NAME=${APP_NAME:-reception-api}
REGION=${REGION:-ap-northeast-2}

PROJECT_NAME=$1
ENV=$2
CLIENT_NAME=${CLIENT_NAME:-${PROJECT_NAME}}

TF_VARS_TPL=${MANIFESTS_DIR}/tfvars.tpl
TF_VARS_NEW=${MANIFESTS_DIR}/$PROJECT_NAME.$ENV.tfvars

echo "Creating tfvars file.."
[ -f "$TF_VARS_NEW" ] && rm -f "$TF_VARS_NEW"
sed "s/{{ REGION }}/${REGION}/; \
	s/{{ VPC_ID }}/${VPC_ID}/; \
	s/{{ APP_NAME }}/${APP_NAME}/; \
	s/{{ PROJECT_NAME }}/${PROJECT_NAME}/; \
	s/{{ ENV }}/${ENV}/; \
	s/{{ CERTIFICATE_ARN }}/${CERTIFICATE_ARN}/; \
	s/{{ CLIENT_NAME }}/${CLIENT_NAME}/; \
	s/{{ KMS_ARN }}/${KMS_ARN}/;" \
	"$TF_VARS_TPL" > "$TF_VARS_NEW"
