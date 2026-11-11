include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//budgets?ref=v0.1.0"
}

# Os e-mails vêm da variável de ambiente PRUMO_ALERT_EMAILS (separados por vírgula),
# para não ficarem expostos neste repositório público.
inputs = {
  monthly_limit_usd    = 40
  alert_thresholds_usd = [20, 40]
  alert_emails         = split(",", get_env("PRUMO_ALERT_EMAILS"))
}
