// Get SSM Parameters

data "aws_ssm_parameter" "rds_endpoint" {
  depends_on = [
    module.create_database
  ]
  name = "/${local.workspace.environment_name}/RDS/ENDPOINT"
}
data "aws_ssm_parameter" "rds_username" {
  depends_on = [
    module.create_database
  ]
  name = "/${local.workspace.environment_name}/RDS/USER"
}
data "aws_ssm_parameter" "rds_password" {
  depends_on = [
    module.create_database
  ]
  name = "/${local.workspace.environment_name}/RDS/PASSWORD"
}
data "aws_ssm_parameter" "rds_db_name" {
  depends_on = [
    module.create_database
  ]
  name = "/${local.workspace.environment_name}/RDS/NAME"
}

//MySQL Provider

provider "mysql" {
  endpoint = "${data.aws_ssm_parameter.rds_endpoint.value}:3306"
  username = "${data.aws_ssm_parameter.rds_username.value}"
  password = "${data.aws_ssm_parameter.rds_password.value}"
}

# Create RDS App users


resource "mysql_database" "newdb" {
    depends_on = [
      module.create_database
    ]
  name = local.workspace.mysql_addons.appdb_name
}


