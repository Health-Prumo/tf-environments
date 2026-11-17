include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//static-site?ref=v0.4.0"
}

# A zona DNS vem da unidade global/dns.
dependency "dns" {
  config_path = "../dns"

  mock_outputs = {
    zone_id = "Z000000000000000MOCK"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

# Landing page em https://healthprumo.online (www redireciona para o domínio principal).
# Conteúdo publicado do repositório Health-Prumo/Prumo-landing com aws s3 sync.
inputs = {
  site_name    = "landing"
  domain_name  = "healthprumo.online"
  zone_id      = dependency.dns.outputs.zone_id
  redirect_www = true
}
