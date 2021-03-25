# imported via env.
variable AWS_KEY_LOCATION {
  type = string
}

variable config {
  default = {
    source          = "./ansible/setup.yml"
    destination     = "~/setup.yml"

    remote_setup    = ["ansible-playbook setup.yml",
                       "export PORT=9090"] # all needs a port variable

    remote_start    = ["sudo npm install",
                      "pm2 start index.js"] 

    remote_exec_api = ["cd src/services/api-endpoint"]

    remote_exec_db  = ["cd src/services/database-mock"]
  }
}


module "infrastructure" {
  for_each = toset(["test1"])
  source = "./setup/aws"
  name = each.key
  AWS_KEY_LOCATION = var.AWS_KEY_LOCATION
  port = 9090
  config = var.config
}

output "endpoints" {
  value = module.infrastructure.*
}
