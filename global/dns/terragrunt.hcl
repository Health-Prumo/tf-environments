include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//dns-zone?ref=v0.3.0"
}

# Domínio registrado na GoDaddy, com o DNS delegado a esta zona.
# Depois do apply, configure na GoDaddy os nameservers de `terragrunt output name_servers`.
inputs = {
  domain_name = "healthprumo.online"
  block_email = true
}
