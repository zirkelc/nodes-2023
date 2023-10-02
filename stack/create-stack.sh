#!/bin/bash

GraphDatabaseVersion="4.4.11"
InstanceType="t3.medium"
Password="nodes-2023"
SSHKeyName="nodes-2023"

REGION=eu-central-1
VERSION=$(echo $GraphDatabaseVersion | sed s/[^A-Za-z0-9]/-/g)
TEMPLATE_BODY="file://stack/template.yaml"
STACK_NAME="nodes-2023-neo4j-v$VERSION"

echo "Creating stack..."
aws cloudformation create-stack \
--capabilities CAPABILITY_IAM \
--stack-name "${STACK_NAME}" \
--template-body ${TEMPLATE_BODY} \
--region ${REGION} \
--parameters \
ParameterKey=GraphDatabaseVersion,ParameterValue=${GraphDatabaseVersion} \
ParameterKey=InstanceType,ParameterValue=${InstanceType} \
ParameterKey=Password,ParameterValue=${Password} \
ParameterKey=SSHKeyName,ParameterValue=${SSHKeyName} \

# check return code
EXITCODE=$?
if [ $EXITCODE -ne 0 ]; then
    echo "Error: aws cloudformation create-stack failed with exit code $EXITCODE"
    exit $EXITCODE
fi

echo "Waiting for stack to complete..."
aws cloudformation wait stack-create-complete --region $REGION --stack-name "$STACK_NAME"

echo "Stack created."