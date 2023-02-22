resource "aws_iam_role" "assignment-ecsTaskExecutionRole" {
  name               = "assignment-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "assignment-ecs-TaskExecutionRole-policy" {
  role       = aws_iam_role.assignment-ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "assignment-api-ecs-TaskExecutionRole-custom-ssm" {
  role       = aws_iam_role.assignment-ecsTaskExecutionRole.name
  policy_arn = aws_iam_policy.ecs_task_execution.arn
}


################################################################
# ECS Task Role
################################################################

resource "aws_iam_role" "ecs_task_role" {
  name               = "${local.application}-${local.env}-ecs-task-general"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_policy_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_exec.arn
}

# Policy definitions

resource "aws_iam_policy" "ecs_task_exec" {
  name   = "${local.application}-${local.env}-exec-general"
  path   = "/"
  policy = data.aws_iam_policy_document.task-exec.json
}

resource "aws_iam_policy" "ecs_task_execution" {
  name   = "${local.env}-assignment-ecsTaskExecution"
  path   = "/"
  policy = data.aws_iam_policy_document.task-execution.json
}
