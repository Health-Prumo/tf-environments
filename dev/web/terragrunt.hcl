include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//static-site?ref=v0.5.0"
}

dependency "dns" {
  config_path = "../../global/dns"

  mock_outputs = {
    zone_id = "Z000000000000000MOCK"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

# Front-end (prumo-web) em https://app.healthprumo.online, como SPA.
# Publicação: scripts/deploy.sh do repositório prumo-web.
inputs = {
  site_name    = "app"
  domain_name  = "app.healthprumo.online"
  zone_id      = dependency.dns.outputs.zone_id
  redirect_www = false
  spa          = true
}
