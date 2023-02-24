#!/bin/bash
name=$1
region=$2
ROLE_ARN=$3
CRED=$(aws sts assume-role --role-arn "${ROLE_ARN}" --role-session-name AWSCLI-Session)
export AWS_ACCESS_KEY_ID=$(echo "${CRED}"| jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "${CRED}"| jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo "${CRED}"| jq -r '.Credentials.SessionToken')
aws sts get-caller-identity 2>&1 > /dev/null
aws eks update-kubeconfig --name $name --region $region 2>&1 > /dev/null
endpoint=$(kubectl get ing argocd-server -n argocd -o json | jq --raw-output .status.loadBalancer.ingress[0].hostname)
pass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "Please use following details to login to ArgoCD:"
echo "Endpoint: $endpoint"
echo "User: Admin"
echo "Pass: $pass"
