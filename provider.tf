provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      env     = local.env
      owner   = "devops"
      project = "assignment"
    }
  }
}

