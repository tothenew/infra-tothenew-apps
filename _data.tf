data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["${local.workspace.account_name}-${local.workspace.aws.region}-${local.workspace.project_name}"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Scope"
    values = ["public"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "tag:Scope"
    values = ["private"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_subnets" "secure" {
  filter {
    name   = "tag:Scope"
    values = ["database"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}



resource "aws_ec2_tag" "public_sub" {
  for_each    = toset(data.aws_subnets.public.ids)
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
} 
resource "aws_ec2_tag" "private_sub" {
  for_each    = toset(data.aws_subnets.private.ids)
  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
} 

