# disabling this rule as it is done on purpose for the `regionName` & `regionCode` in the local and variable names so that they match the product docs so it is easier to follow.
rule "terraform_naming_convention" {
  enabled = false
}

# disabling as pattern module and not applicable for this module
rule "required_output_rmfr7" {
  enabled = false
}

