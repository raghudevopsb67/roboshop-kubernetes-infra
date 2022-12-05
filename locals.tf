//locals {
//  app_private_subnets      = lookup(lookup(lookup({ for k, v in module.vpc.private_subnets : "subnets" => v.subnets }, "subnets", null), "app", null), "subnets", null)
//  database_private_subnets = lookup(lookup(lookup({ for k, v in module.vpc.private_subnets : "subnets" => v.subnets }, "subnets", null), "database", null), "subnets", null)
//  frontend_private_subnets = lookup(lookup(lookup({ for k, v in module.vpc.private_subnets : "subnets" => v.subnets }, "subnets", null), "frontend", null), "subnets", null)
//  public_subnets           = lookup(lookup(lookup({ for k, v in module.vpc.public_subnets : "subnets" => v.subnets }, "subnets", null), "public", null), "subnets", null)
//}
//
////output "public_subnets" {
////  value = local.public_subnets[*].id
////}
//

locals {
  alb = {
    public = {
      vpc_cidr = "0.0.0.0/0"
      subnets  = flatten([for i, j in module.vpc : j.public_subnets["public"]["subnets"][*].id])
    }
    private = {
      vpc_cidr = element([for i, j in module.vpc : j.vpc_cidr], 0)
      subnets  = flatten([for i, j in module.vpc : j.private_subnets["app"]["subnets"][*].id])
    }
  }
  merged_alb = tomap({
    for i in keys(var.alb) : i => {
      internal = var.alb[i].internal
      vpc_cidr = local.alb[i].vpc_cidr
      subnets  = local.alb[i].subnets
    }
  })
}
