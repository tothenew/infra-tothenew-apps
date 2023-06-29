# Pre-provisioning steps:

## Setup VPC and Terraform Server
Using terraform from local machine/laptop

- Create file vpc.tf
```
module "network" {
  source = "git::https://github.com/DNXLabs/terraform-aws-network.git?ref=1.8.5"

  newbits             = 4
  vpc_cidr            = 10.0.0.0/16
  name                = vpc-common
  multi_nat           = false
  transit_subnet      = false

  tags = {
    "CreatedBy" = "Terraform"
  }
}
```
-  Create ec2.tf

```
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  # using default VPC
  vpc_id      = module.network.vpc_id
  ingress {
    description = "SSH to VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    # allow all traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
variable "ami_id" {
  description = "Ubuntu ami id"

  # Amazon linux image
  default     = "ami-0a23ccb2cdd9286bb"
}

```
```
$ sudo apt-get update
$ sudo apt-get install ca-certificates curl gnupg lsb-release
$ sudo mkdir -p /etc/apt/keyrings
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
$ echo \
 "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
$ sudo apt-get update
$ sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
$ sudo usermod -aG docker $USER
$ sudo apt-get install -y make
```

Follow the below link for futher steps
https://docs.google.com/presentation/d/128SVECo38n2EMq-xkvyWvIL49lIx35aI5y1zzy8X7kA/edit#slide=id.g1eddf51fb0d_0_379

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.3 |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.23.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.10.0 |
| <a name="requirement_mysql"></a> [mysql](#requirement\_mysql) | 3.0.27 |
| <a name="requirement_rabbitmq"></a> [rabbitmq](#requirement\_rabbitmq) | 1.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.23.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.10.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster_autoscaler"></a> [cluster\_autoscaler](#module\_cluster\_autoscaler) | git::https://github.com/tothenew/terraform-aws-eks.git//modules/terraform-aws-eks-cluster-autoscaler | n/a |
| <a name="module_create_database"></a> [create\_database](#module\_create\_database) | git::https://github.com/tothenew/terraform-aws-rds.git | v0.0.1 |
| <a name="module_eks_cluster"></a> [eks\_cluster](#module\_eks\_cluster) | git::https://github.com/tothenew/terraform-aws-eks.git | v0.0.1 |
| <a name="module_helm_iam_policy"></a> [helm\_iam\_policy](#module\_helm\_iam\_policy) | git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-policy | n/a |
| <a name="module_load_balancer_controller"></a> [load\_balancer\_controller](#module\_load\_balancer\_controller) | git::https://github.com/tothenew/terraform-aws-eks.git//modules/terraform-aws-eks-lb-controller | n/a |
| <a name="module_node_termination_handler"></a> [node\_termination\_handler](#module\_node\_termination\_handler) | git::https://github.com/tothenew/terraform-aws-eks.git//modules/terraform-aws-eks-node-termination-handler | n/a |
| <a name="module_secrets-store-csi"></a> [secrets-store-csi](#module\_secrets-store-csi) | git::https://github.com/tothenew/terraform-aws-eks.git//modules/secret-store-csi | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ec2_tag.private_sub](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/resources/ec2_tag) | resource |
| [aws_ec2_tag.public_sub](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/resources/ec2_tag) | resource |
| [aws_iam_policy.example](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/resources/iam_policy) | resource |
| [aws_iam_role.instance](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.core_service-role](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.secrets_integration_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.datastore](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.datastore-acl](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_public_access_block.public_access_block_input](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/resources/s3_bucket_public_access_block) | resource |
| [helm_release.kube-prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.monitoring](https://registry.terraform.io/providers/hashicorp/kubernetes/2.10.0/docs/resources/namespace) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.example](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.instance-assume-role-policy](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/data-sources/iam_policy_document) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/data-sources/subnets) | data source |
| [aws_subnets.secure](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/data-sources/subnets) | data source |
| [aws_vpc.selected](https://registry.terraform.io/providers/hashicorp/aws/4.23.0/docs/data-sources/vpc) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_core-service-role"></a> [core-service-role](#output\_core-service-role) | n/a |
| <a name="output_shared-apps-helm-integration-role"></a> [shared-apps-helm-integration-role](#output\_shared-apps-helm-integration-role) | n/a |
<!-- END_TF_DOCS -->
