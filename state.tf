terraform {
  backend "s3" {
    bucket               = "terraform-project-sree"
    key                  = "terraform.tfstate"
    region               = "us-east-1"
    workspace_key_prefix = "dev"
  }
}
