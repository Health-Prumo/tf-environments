include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//serverless-api?ref=v0.5.0"
}

dependency "network" {
  config_path = "../network"

  mock_outputs = {
    private_subnet_ids    = ["subnet-00000000000000001", "subnet-00000000000000002"]
    app_security_group_id = "sg-00000000000000001"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "data" {
  config_path = "../data"

  mock_outputs = {
    table_name = "prumo-dev-dados"
    table_arn  = "arn:aws:dynamodb:us-east-1:444331926746:table/prumo-dev-dados"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "auth" {
  config_path = "../auth"

  mock_outputs = {
    client_id  = "mockclientid000000000000000"
    issuer_url = "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_MOCK"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

dependency "dns" {
  config_path = "../../global/dns"

  mock_outputs = {
    zone_id = "Z000000000000000MOCK"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

locals {
  origens = ["https://app.healthprumo.online", "http://localhost:5173"]
}

# API em https://api.healthprumo.online. Código publicado pelo scripts/deploy.sh do prumo-api.
inputs = {
  handler             = "prumo_api.handler.handler"
  subnet_ids          = dependency.network.outputs.private_subnet_ids
  security_group_ids  = [dependency.network.outputs.app_security_group_id]
  dynamodb_table_arns = [dependency.data.outputs.table_arn]
  jwt_issuer          = dependency.auth.outputs.issuer_url
  jwt_audience        = [dependency.auth.outputs.client_id]
  cors_allow_origins  = local.origens
  # O preflight do navegador vem sem token: sem esta rota, o $default (com JWT) responde 401.
  public_routes = ["GET /saude", "OPTIONS /{proxy+}"]
  domain_name   = "api.healthprumo.online"
  zone_id       = dependency.dns.outputs.zone_id

  environment_variables = {
    PRUMO_AMBIENTE = "dev"
    PRUMO_AUTH     = "cognito"
    PRUMO_TABELA   = dependency.data.outputs.table_name
    PRUMO_IA       = "mock" # Coach e card por regras, sem IA generativa
    PRUMO_ORIGENS  = join(",", local.origens)
  }
}
