locals {
  name = "my-simple-instance"

  application = "my-instance"
  product = "my-product"
  team = "my-team"
  environment = "qa"
  bu = "my-bu"
}

module "aws_instance" {
  source = "git@github.com:PicPay/tech-cross-terraform-blueprints.git//ec2"

  name = local.name

  application = local.application
  product = local.product
  team = local.team
  environment = local.environment
  bu = local.bu

  ami           = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"
  key_name      = "teste-ec2"
  monitoring    = false
}