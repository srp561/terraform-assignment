data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task-exec" {
  statement {
    sid = "AllowECSEXEC"

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = ["*"]
  }
  statement {
    sid = "AllowReadSSM"
    actions = [
      "ssm:Describe*",
      "ssm:Get*",
      "ssm:List*",
    ]
    resources = ["arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/${local.env}/assignment/*"]
  }
  statement {
    sid = "AllowReadSSMByPath"
    actions = [
      "ssm:GetParametersByPath"
    ]
    resources = ["arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/${local.env}/assignment/*"]
  }
}


data "aws_iam_policy_document" "task-execution" {
  statement {
    sid = "AllowReadSSM"
    actions = [
      "ssm:Describe*",
      "ssm:Get*",
      "ssm:List*",
    ]
    resources = ["arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/${local.env}/assignment/*"]

  }

  statement {
    sid = "AllowReadSSMByPath"
    actions = [
      "ssm:GetParametersByPath"
    ]
    resources = ["arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:parameter/${local.env}/assignment/*"]
  }
}
