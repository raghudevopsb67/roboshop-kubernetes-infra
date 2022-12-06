module "vpc" {
  for_each                  = var.vpc
  source                    = "./vendor/modules/vpc"
  cidr_block                = each.value.cidr_block
  additional_cidr_block     = each.value.additional_cidr_block
  private_subnets           = each.value.private_subnets
  public_subnets            = each.value.public_subnets
  subnet_availability_zones = each.value.subnet_availability_zones
  env                       = var.env
  management_vpc            = var.management_vpc
  private_zone_id           = var.private_zone_id
}

module "docdb" {
  for_each            = var.docdb
  source              = "./vendor/modules/docdb"
  name                = each.key
  engine              = each.value.engine
  env                 = var.env
  subnets             = flatten([for i, j in module.vpc : j.private_subnets["database"]["subnets"][*].id])
  nodes               = each.value.nodes
  skip_final_snapshot = each.value.skip_final_snapshot
  vpc_id              = element([for i, j in module.vpc : j.vpc_id], 0)
  vpc_cidr            = element([for i, j in module.vpc : j.vpc_cidr], 0)
  BASTION_NODE        = var.BASTION_NODE
}

module "rds" {
  source              = "./vendor/modules/rds"
  for_each            = var.rds
  env                 = var.env
  subnets             = flatten([for i, j in module.vpc : j.private_subnets["database"]["subnets"][*].id])
  name                = each.key
  allocated_storage   = each.value.allocated_storage
  engine              = each.value.engine
  engine_version      = each.value.engine_version
  instance_class      = each.value.instance_class
  skip_final_snapshot = each.value.skip_final_snapshot
  vpc_id              = element([for i, j in module.vpc : j.vpc_id], 0)
  vpc_cidr            = element([for i, j in module.vpc : j.vpc_cidr], 0)
  BASTION_NODE        = var.BASTION_NODE
  nodes               = each.value.nodes
}


module "elasticache" {
  source          = "./vendor/modules/elasticache"
  for_each        = var.elasticache
  env             = var.env
  subnets         = flatten([for i, j in module.vpc : j.private_subnets["database"]["subnets"][*].id])
  name            = each.key
  engine          = each.value.engine
  engine_version  = each.value.engine_version
  node_type       = each.value.node_type
  num_cache_nodes = each.value.num_cache_nodes
  vpc_id          = element([for i, j in module.vpc : j.vpc_id], 0)
  vpc_cidr        = element([for i, j in module.vpc : j.vpc_cidr], 0)
}

module "rabbitmq" {
  source          = "./vendor/modules/rabbitmq"
  for_each        = var.rabbitmq
  env             = var.env
  subnets         = flatten([for i, j in module.vpc : j.private_subnets["database"]["subnets"][*].id])
  name            = each.key
  instance_type   = each.value.instance_type
  private_zone_id = var.private_zone_id
  BASTION_NODE    = var.BASTION_NODE
  vpc_id          = element([for i, j in module.vpc : j.vpc_id], 0)
  vpc_cidr        = element([for i, j in module.vpc : j.vpc_cidr], 0)
}

module "alb" {
  source   = "./vendor/modules/alb"
  for_each = local.merged_alb
  env      = var.env
  subnets  = each.value.subnets
  name     = each.key
  vpc_id   = element([for i, j in module.vpc : j.vpc_id], 0)
  vpc_cidr = element([for i, j in module.vpc : j.vpc_cidr], 0)
  internal = each.value.internal
}

module "EKS" {
  source                  = "./vendor/modules/eks/"
  ENV                     = var.env
  PRIVATE_SUBNET_IDS      = flatten([for i, j in module.vpc : j.private_subnets["database"]["subnets"][*].id])
  PUBLIC_SUBNET_IDS       = flatten([for i, j in module.vpc : j.public_subnets["public"]["subnets"][*].id])
  DESIRED_SIZE            = 1
  MAX_SIZE                = 1
  MIN_SIZE                = 1
  CREATE_ALB_INGRESS      = false
  CREATE_EXTERNAL_SECRETS = false
  INSTALL_KUBE_METRICS    = false
  CREATE_SCP              = true
}
