locals {
  name = var.name == null ? null : var.name
  environment = lower(trimspace(var.environment))
  team        = lower(trimspace(var.team))
  product     = lower(trimspace(var.product))
  application = lower(trimspace(var.application))
  bu          = lower(trimspace(var.application))

  resources_name = var.name != null ? module.tags.name : format(module.tags.name)
}

module "tags" {
  source = "git@github.com:PicPay/tech-cross-terraform-modules.git//tags"

  name = local.name

  product     = var.product
  application = var.application
  environment = var.environment
  team        = var.team
  bu          = var.bu
  custom_tags = var.custom_tags
}

module "ec2_instance" {
  source = "git@github.com:PicPay/tech-cross-terraform-modules.git//ec2"

  ami                  = var.ami
  instance_type        = var.instance_type
  cpu_core_count       = var.cpu_core_count
  cpu_threads_per_core = var.cpu_threads_per_core
  hibernation          = var.hibernation

  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64
  user_data_replace_on_change = var.user_data_replace_on_change

  availability_zone      = var.availability_zone
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  key_name             = var.key_name
  monitoring           = var.monitoring
  get_password_data    = var.get_password_data
  iam_instance_profile = var.iam_instance_profile

  associate_public_ip_address = var.associate_public_ip_address
  private_ip                  = var.private_ip
  secondary_private_ips       = var.secondary_private_ips
  ipv6_address_count          = var.ipv6_address_count
  ipv6_addresses              = var.ipv6_addresses

  ebs_optimized = var.ebs_optimized

  root_block_device = [
    for block_device in var.root_block_device :
    {
      encrypted   = try(block_device.encrypted)
      volume_type = try(block_device.volume_type)
      throughput  = try(block_device.throughput)
      volume_size = try(block_device.volume_size)
      tags = module.tags.tags
    }
  ]

  ebs_block_device = [
    for ebs_block_device in var.ebs_block_device:
    {
      delete_on_termination = try(ebs_block_device.delete_on_termination)
      device_name           = try(ebs_block_device.device_name)
      encrypted             = try(ebs_block_device.encrypted)
      iops                  = try(ebs_block_device.iops)
      snapshot_id           = try(ebs_block_device.snapshot_id)
      volume_size           = try(ebs_block_device.volume_size)
      volume_type           = try(ebs_block_device.volume_type)
      throughput            = try(ebs_block_device.throughput)
    }
  ]
}