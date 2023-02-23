output "core-service-role" {
  value = aws_iam_role.instance.arn
}
output "shared-apps-helm-integration-role" {
    value =   module.secrets-store-csi.iam_role_arn
}
