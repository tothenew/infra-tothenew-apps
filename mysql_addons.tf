// Get SSM Parameters

data "aws_ssm_parameter" "rds_endpoint" {
  depends_on = [
    module.create_database
  ]
  name = "/${local.workspace.rds.environment}/RDS/ENDPOINT"
}
data "aws_ssm_parameter" "rds_username" {
  depends_on = [
    module.create_database
  ]
  name = "/${local.workspace.rds.environment}/RDS/USER"
}
data "aws_ssm_parameter" "rds_password" {
  depends_on = [
    module.create_database
  ]
  name = "/${local.workspace.rds.environment}/RDS/PASSWORD"
}
data "aws_ssm_parameter" "rds_db_name" {
  depends_on = [
    module.create_database
  ]
  name = "/${local.workspace.rds.environment}/RDS/NAME"
}

//MySQL Provider

provider "mysql" {
  endpoint = "${data.aws_ssm_parameter.rds_endpoint.value}:3306"
  username = "${data.aws_ssm_parameter.rds_username.value}"
  password = "${data.aws_ssm_parameter.rds_password.value}"
}

# Create RDS App users

resource "random_string" "app_password" {
  count = length(local.workspace.mysql_addons.app_user_names)
  length  = 34
  special = false
}
resource "mysql_user" "app_user" {
  count = length(local.workspace.mysql_addons.app_user_names)
  user               = local.workspace.mysql_addons.app_user_names[count.index]
  host               = "%"
  plaintext_password = random_string.app_password[count.index].result
}
resource "mysql_grant" "app_user" {
  count = length(local.workspace.mysql_addons.app_user_names)
  user       = mysql_user.app_user[count.index].user
  host       = mysql_user.app_user[count.index].host
  database   = data.aws_ssm_parameter.rds_db_name.value
  privileges = ["SELECT", "UPDATE", "INSERT", "DELETE", "CREATE", "ALTER", "REFERENCES"]
}
resource "aws_ssm_parameter" "app_username" {
  count = length(local.workspace.mysql_addons.app_user_names)
  name        = "/${local.workspace.environment_name}/RDS/${local.workspace.mysql_addons.app_user_names[count.index]}/USERNAME"
  description = "${local.workspace.mysql_addons.app_user_names[count.index]} Username"
  type        = "String"
  value       = mysql_user.app_user[count.index].user

}
resource "aws_ssm_parameter" "app_password" {
  count = length(local.workspace.mysql_addons.app_user_names)
  name        = "/${local.workspace.environment_name}/RDS/${local.workspace.mysql_addons.app_user_names[count.index]}/PASSWORD"
  description = "${local.workspace.mysql_addons.app_user_names[count.index]} Password"
  type        = "SecureString"
  value       = random_string.app_password[count.index].result

}

resource "mysql_database" "app" {
    depends_on = [
      module.create_database
    ]
  name = local.workspace.mysql_addons.addondb_name
}
resource "aws_ssm_parameter" "addondb_name" {
  name        = "/${local.workspace.environment_name}/addondb/NAME"
  description = "addon database name"
  type        = "String"
  value       = mysql_database.app.name
}


 }
