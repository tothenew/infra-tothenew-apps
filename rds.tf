module "create_database" {
  source              = "git::https://github.com/tothenew/terraform-aws-rds.git?ref=v0.0.1"
  create_rds     = false
  create_aurora = true
  subnet_ids = data.aws_subnets.secure.ids
  vpc_id           = data.aws_vpc.selected.id
  vpc_cidr         = [data.aws_vpc.selected.cidr_block]
  db_subnet_group_id = "${local.workspace.project_name}-${local.workspace.environment_name}-dbsubnet-group"
  publicly_accessible = false
  project_name_prefix = "${local.workspace.project_name}-${local.workspace.environment_name}-rds-cluster"
  allocated_storage = local.workspace["rds"]["allocated_storage"]
  engine = local.workspace["rds"]["engine"]
  engine_version = local.workspace["rds"]["engine_version"]
#  db_parameter_group_name=local.workspace["rds"]["parameter_group_name"]
  instance_class = local.workspace["rds"]["instance_class"]
  database_name = local.workspace["rds"]["db_name"]
  username   = "root"
  apply_immediately = false
#  storage_encrypted = local.workspace["rds"]["storage_encrypted"]
 # kms_key_arn = aws_kms_key.rds_key.arn
  multi_az = false
  deletion_protection = false
  auto_minor_version_upgrade = false
  count_aurora_instances = 1
  serverlessv2_scaling_configuration_max = local.workspace.rds.serverlessv2_scaling_configuration_max
  serverlessv2_scaling_configuration_min = local.workspace.rds.serverlessv2_scaling_configuration_min
  environment = local.workspace["environment_name"]
  common_tags = local.tags
}

