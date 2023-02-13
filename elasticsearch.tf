module "elasticsearch" {
  source                       = "git::https://github.com/tothenew/terraform-aws-elasticsearch.git?ref=v0.0.2"
  create_aws_elasticsearch     = false
  create_aws_ec2_elasticsearch = true
  instance_count               = local.workspace.elasticsearch.instance_count
  instance_type                = local.workspace.elasticsearch.instance_type
  project_name_prefix          = local.workspace.environment_name
  security_group_ids           = [aws_security_group.es-sg.id]
  subnet_ids                   = data.aws_subnets.private.ids
  volume_size                  = local.workspace["elasticsearch"]["volume_size"]
  vpc_id                       = data.aws_vpc.selected.id
  key_name                     = local.workspace["key_name"]
  volume_type                  = local.workspace["elasticsearch"]["volume_type"]
}
