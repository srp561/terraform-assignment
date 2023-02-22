resource "aws_cloudwatch_log_group" "assignment-log-group" {
  name              = "/aws/ecs/${local.application}/${local.env}"
  retention_in_days = local.log_days
}
