#!/bin/bash

if [ -z "$STACK_NAME" ]; then
  read -r -p "Enter stack name: " STACK_NAME

  if [ -z "$STACK_NAME" ]; then
    echo "Stack name is required!"
    exit 1
  fi
fi

REGION=eu-central-1

echo "Deleting stack..."
aws cloudformation delete-stack --stack-name "$STACK_NAME" --region "$REGION"
echo "Waiting for stack to complete..."
aws cloudformation wait stack-delete-complete --region $REGION --stack-name "$STACK_NAME"
echo "Stack deleted."
