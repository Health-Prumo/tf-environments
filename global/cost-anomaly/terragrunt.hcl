include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/Health-Prumo/tf-blueprint.git//cost-anomaly?ref=v0.2.0"
}

# E-mails em PRUMO_ANOMALY_EMAILS (separados por vírgula), fora deste repositório público.
inputs = {
  impact_threshold_usd = 5
  frequency            = "DAILY"
  alert_emails         = split(",", get_env("PRUMO_ANOMALY_EMAILS"))
}
