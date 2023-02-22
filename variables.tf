variable "aws_region" {
  default = "us-east-1"
}

variable "image_tag" {
  description = "docker image tag from the repo"
  type        = string
  default     = "latest"
}

variable "repo_url" {
  description = "repository URL"
  type        = string
  default     = "399348531980.dkr.ecr.us-east-1.amazonaws.com/terraform-project"
}

variable "container_memory" {
  description = "Specifying the memory our container requires"
  type        = string
  default     = "512"
}

variable "container_cpu" {
  description = "Specifying the CPU our container requires"
  type        = string
  default     = "256"
}

variable "app_port" {
  description = "APP Port"
  type        = string
  default     = "8080"
}



locals {

  work = terraform.workspace == "default" ? "no-workspace" : terraform.workspace
  # expects workspace to be set to 'dev', for example dev which means environment - dev
  env = element(split("-", local.work), 0)


  # we have vpc-devops-dev for dev env and vpc-docker-prod for prod
  vpc_group_map = {
    dev = "app"
  }

  vpc_group = lookup(local.vpc_group_map, local.work, "")

  vpc_env_map = {
    dev = "devops"
  }

  vpc_env = lookup(local.vpc_env_map, local.work, "")

  application = "assignment"
  log_days_map = {
    dev = 1
  }
  log_days = lookup(local.log_days_map, local.work, 1)

  aws_ingress_cidr_map = {
    dev = ["0.0.0.0/0"]
  }

  aws_ingress_cidr = lookup(local.aws_ingress_cidr_map, local.work, ["0.0.0.0/0"])

  containers_count_map = {
    dev = 1
  }

  containers_count = lookup(local.containers_count_map, local.work, "1")
}
