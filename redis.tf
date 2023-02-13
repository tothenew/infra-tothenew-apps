module "terraform-aws-elasticache" {
  source             = "git::https://github.com/tothenew/terraform-aws-elasticache?ref=v0.0.1"
  env                = local.workspace.environment_name
  name               = "${local.workspace.project_name}-Redis-cluster"
  engine             = "redis"
  clusters           = local.workspace.cache.redis.clusters
  failover           = local.workspace.cache.redis.failover
  subnets            = data.aws_subnets.private.ids 
  vpc_id             = data.aws_vpc.selected.id
  availability_zones = local.workspace.cache.redis.availability_zones
  node_type          = local.workspace.cache.redis.node_type
  cluster_version    = local.workspace.cache.redis.cluster_version
  allowed_cidr       = [data.aws_vpc.selected.cidr_block]
}