terraform {
  backend "s3" {
    bucket = "iatao-state-dev"
    key    = "dev/iata.tfstate"
    region = "us-east-1"
    profile = "shubham-dev"
    dynamodb_table = "iata-dev-state"
  }
}

module "s3" {
  source        = "../../module/cloudfront"
  env           = var.env
  app           = var.app
  mircofrontend = var.mf
  tags          = var.tags
}

module "vpc" {
  source              = "../../module/vpc"
  env                 = var.env
  app                 = var.app
  availability_zone   = ["us-east-1a", "us-east-1b", "us-east-1c"]
  vpc_cidr_block      = "10.0.0.0/16"
  private_cidr_block  = ["10.0.1.0/24", "10.0.2.0/24"]
  public_cidr_block   = ["10.0.3.0/24", "10.0.4.0/24"]
  database_cidr_block = ["10.0.5.0/24"]
}

module "alb" {
  source             = "../../module/alb"
  env                = var.env
  app                = var.app
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_tls.id]
  public_subnets     = module.vpc.public_subnet_id
  private_subnets    = module.vpc.private_subnet_id
  vpc_id             = module.vpc.vpc_id
  app_config = {
    kidswear = {
      priority     = 100
      path_pattern = "/kidswear/*"
      port         = 8081
    },
    footwear = {
      priority     = 200
      path_pattern = "/footwear/*"
      port         = 8082
    },
    gadgets = {
      priority     = 300
      path_pattern = "/gadgets/*"
      port         = 8083
    }
  }
}
