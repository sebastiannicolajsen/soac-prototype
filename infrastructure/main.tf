# imported via env.
variable AWS_KEY_LOCATION {
  type = string
}

variable GOOGLE_KEY_LOCATION {
  type = string
}

variable config {
  default = {
    source            = "./ansible/setup.yml"
    destination       = "~/setup.yml"

    remote_setup      = ["ansible-playbook setup.yml",
                         "export PORT=9090"] # all needs a port variable

    remote_start      = ["sudo npm install",
                         "pm2 start index.js"]

    remote_exec_api   = ["cd src/services/api-endpoint"]

    remote_exec_db    = ["cd src/services/database-mock"]

    remote_exec_proxy = ["cd src/services/service-proxy"]
  }
}


# resource to extend with new services
locals {
  test = true

  proxy = { # proxy which exposes all services through same endpoint
    name = "proxy"
    port = 9090
  }

  aws_services = [ # all aws services
    {
      name = "aws1"
      port = 9090
    },
    {
      name = "aws2"
      port = 9090
    }
  ]

  google_services = [ # all google services
    {
      name = "google1"
      port = 9090
    }
  ]
}

# add infrastructure for each service set:

# AWS loader
module "aws_inf" {
  for_each = { for serv in local.aws_services : serv.name => serv }
  source = "./setup/aws"
  name = each.key
  AWS_KEY_LOCATION = var.AWS_KEY_LOCATION
  port = each.value.port
  config = var.config
}

# Google loader
module "google_inf" {
  for_each = { for serv in local.google_services : serv.name => serv }
  source = "./setup/google"
  name = each.key
  GOOGLE_KEY_LOCATION = var.GOOGLE_KEY_LOCATION
  port = each.value.port
  config = var.config
}

module "proxy" {
    source = "./setup/proxy"
    name = local.proxy.port
    AWS_KEY_LOCATION = var.AWS_KEY_LOCATION
    services = merge(module.aws_inf,module.google_inf)
    port = local.proxy.port
    config = var.config
}

output "endpoints" {
  value = merge(module.aws_inf,module.google_inf)
}

output "proxy" {
  value = module.proxy.*
}
