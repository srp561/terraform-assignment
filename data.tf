data "aws_vpc" "vpc" {
  tags = {
    env   = local.vpc_env
    group = local.vpc_group
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  tags = {
    layer = "public"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  tags = {
    layer = "private"
  }
}

data "aws_caller_identity" "current" {}
