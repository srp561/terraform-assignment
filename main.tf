resource "aws_ecs_cluster" "assignment-cluster" {
  name = "${local.env}-assignment"
}

data "template_file" "assignment" {
  template = <<DEFINITION
  [
    {
      "name": "${local.env}-${local.application}",
      "image": "${var.repo_url}:${var.image_tag}",
      "linuxParameters": {
          "initProcessEnabled": true
      },
      "essential": true,
      "portMappings": [
        {
          "containerPort": 8080
                }
      ],
      "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-region" : "us-east-1",
                    "awslogs-group" : "${aws_cloudwatch_log_group.assignment-log-group.name}",
                    "awslogs-stream-prefix" : "assignment"
                }
            },
            "environment": [
            {
               "name": "ENV",
               "value": "${local.env}"
            }
          ],
      "memoryReservation": 512,
      "cpu": 256
    }
  ]
  DEFINITION
}

resource "aws_ecs_task_definition" "assignment-task" {
  family                   = "${local.env}-${local.application}"
  container_definitions    = data.template_file.assignment.rendered
  requires_compatibilities = ["FARGATE"]          # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"             # Using awsvpc as our network mode as this is required for Fargate
  memory                   = var.container_memory # Specifying the memory our container requires
  cpu                      = var.container_cpu    # Specifying the CPU our container requires
  execution_role_arn       = aws_iam_role.assignment-ecsTaskExecutionRole.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
}

resource "aws_ecs_service" "assignment-service" {
  name                   = "${local.env}-${local.application}-service" # Naming our first service
  cluster                = aws_ecs_cluster.assignment-cluster.id       # Referencing our created Cluster
  task_definition        = aws_ecs_task_definition.assignment-task.arn # Referencing the task our service will spin up
  launch_type            = "FARGATE"
  desired_count          = local.containers_count
  enable_execute_command = true

  load_balancer {
    target_group_arn = aws_lb_target_group.assignment-alb-tg.arn # Referencing our target group
    container_name   = "${local.env}-${local.application}"
    container_port   = 8080 # Specifying the container port
  }

  network_configuration {
    subnets          = tolist(data.aws_subnets.public.ids)
    assign_public_ip = true
    security_groups  = [aws_security_group.assignment-alb-sg-containers.id]
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

}

