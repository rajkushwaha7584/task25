#############################################
# Local Terraform Guardrails
#############################################

resource "terraform_data" "guardrails" {
  input = {
    aws_region           = var.aws_region
    environment          = var.environment
    expected_environment = var.expected_environment
    project_name         = var.project_name
    owner                = var.owner
  }

  lifecycle {
    precondition {
      condition     = contains(var.allowed_environments, var.environment)
      error_message = "Environment must be one of the approved environment names."
    }

    precondition {
      condition     = var.environment == var.expected_environment
      error_message = "This environment folder is being used with the wrong environment value."
    }

    precondition {
      condition     = lookup(var.environment_region_map, var.environment, "") == var.aws_region
      error_message = "This environment is not allowed to deploy in the selected AWS region."
    }

    precondition {
      condition     = trimspace(var.project_name) != "" && trimspace(var.owner) != ""
      error_message = "project_name and owner are required for default tags."
    }
  }
}
