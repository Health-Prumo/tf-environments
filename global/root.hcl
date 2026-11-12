# Recursos de escopo da conta (orçamento, alertas). Sem relação com um ambiente de app.
locals {
  account_id = "444331926746"
  region     = "us-east-1"
  basename   = "prumo"
  env        = "global"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket       = "${local.basename}-terraform-state-${local.account_id}"
    key          = "${local.env}/${path_relative_to_include()}/terraform.tfstate"
    region       = local.region
    encrypt      = true
    use_lockfile = true
  }
}

# allowed_account_ids impede rodar na conta errada, mesmo com outro AWS_PROFILE ativo.
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOT
provider "aws" {
  region              = "${local.region}"
  allowed_account_ids = ["${local.account_id}"]

  default_tags {
    tags = {
      Projeto       = "Prumo"
      Ambiente      = "${local.env}"
      GerenciadoPor = "Terraform"
      Repositorio   = "Health-Prumo/tf-environments"
      ze            = "porvux"
    }
  }
}
EOT
}

inputs = {
  basename    = local.basename
  environment = local.env
  region      = local.region
}
