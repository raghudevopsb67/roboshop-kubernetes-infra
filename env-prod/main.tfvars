env = "prod"

vpc = {
  vpc1 = {
    cidr_block            = "10.200.0.0/16"
    additional_cidr_block = []
    private_subnets = {
      frontend = {
        cidr_block = ["10.200.0.0/24", "10.200.1.0/24"]
        name       = "frontend"
        attach_to  = "ngw"
      }
      database = {
        cidr_block = ["10.200.2.0/24", "10.200.3.0/24"]
        name       = "database"
        attach_to  = "ngw"
      }
      app = {
        cidr_block = ["10.200.4.0/24", "10.200.5.0/24"]
        name       = "app"
        attach_to  = "ngw"
      }
    }
    public_subnets = {
      public = {
        cidr_block = ["10.200.255.0/24", "10.200.254.0/24"]
        name       = "public"
        attach_to  = "igw"
      }
    }
    subnet_availability_zones = ["us-east-1a", "us-east-1b"]
  }

}

management_vpc = {
  vpc_id      = "vpc-075435ce9af088bfa"
  route_table = "rtb-032742c71bcb7a780"
  vpc_cidr    = "172.31.0.0/16"
}


docdb = {
  db1 = {
    engine              = "docdb"
    skip_final_snapshot = true
    nodes = {
      one = {
        instance_class = "db.t3.medium"
      }
    }
  }
}

rds = {
  db1 = {
    allocated_storage   = 10
    engine              = "aurora-mysql"
    engine_version      = "5.7.mysql_aurora.2.10.2"
    instance_class      = "db.t3.micro"
    skip_final_snapshot = true
    nodes = {
      one = {
        instance_class = "db.t3.small"
      }
    }
  }
}

elasticache = {
  ec1 = {
    engine          = "redis"
    engine_version  = "6.2"
    node_type       = "cache.t3.micro"
    num_cache_nodes = 1
  }
}

rabbitmq = {
  mq1 = {
    instance_type = "t3.micro"
  }
}

BASTION_NODE    = "172.31.2.218/32"
private_zone_id = "Z02090163Q152ZKQQQT6A"
public_zone_id  = "Z054900412BD6N5CVSC0X"
PROMETHEUS_NODE = "172.31.14.134/32"

alb = {
  public = {
    internal = false
  }
  private = {
    internal = true
  }
}

ACM_ARN = "arn:aws:acm:us-east-1:633788536644:certificate/733207e0-3421-452c-b4a0-6e3565e1b622"

eks = {
  prod = {
    DESIRED_SIZE            = 1
    MAX_SIZE                = 1
    MIN_SIZE                = 1
    CREATE_ALB_INGRESS      = false
    CREATE_EXTERNAL_SECRETS = false
    INSTALL_KUBE_METRICS    = false
  }
}
