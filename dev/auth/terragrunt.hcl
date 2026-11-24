include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//cognito-auth?ref=v0.5.0"
}

# Login por e-mail e senha (Cognito Lite). O client_id vai para o .env.production do prumo-web.
inputs = {
  app_name = "Prumo"
}
