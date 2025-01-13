# Create Cognito user pool
resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.project_name}-user-pool"

  # Configure sign-in options
  #username_attributes = ["username"]
  mfa_configuration = "OFF"

  # Configure email provider
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  # Configure hosted authentication pages
  admin_create_user_config {
    allow_admin_create_user_only = false
  }
}

resource "random_string" "domain_suffix" {
  length  = 6
  special = false
  upper   = false
}


# Configuring Cognito domain
resource "aws_cognito_user_pool_domain" "auth_domain" {
  domain       = "${var.project_name}-auth-${random_string.domain_suffix.result}"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

# Configureing App Client
resource "aws_cognito_user_pool_client" "cognito_appclient" {
  name         = "${var.project_name}-cognito_appclient"
  user_pool_id = aws_cognito_user_pool.user_pool.id

  token_validity_units {
    refresh_token = "days"    # "seconds", "minutes", "hours", "days"
    access_token  = "minutes" # "seconds", "hours", "days"
    id_token      = "hours"   # "seconds", "minutes", "days"
  }
  refresh_token_validity = 30 # 30 days
  access_token_validity  = 60 # 60 minutes
  id_token_validity      = 1  # 1 hour

  generate_secret               = false
  prevent_user_existence_errors = "ENABLED" # "LEGACY", "ENABLED"
  explicit_auth_flows           = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  enable_token_revocation       = true

  callback_urls                        = ["https://google.com"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "phone", "profile"]
  supported_identity_providers         = ["COGNITO"]
}

# Adding an user
resource "aws_cognito_user" "example_user" {
  user_pool_id = aws_cognito_user_pool.user_pool.id
  username     = "Teste"
  password     = "Teste123!"

  attributes = {
    email          = "no-reply@foo.com"
    email_verified = true
  }
}