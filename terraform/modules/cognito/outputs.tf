# Output Cognito User Pool ID (needed on Lambdas as and EBV variable)
output "cognito_userpool_id" {
  value = aws_cognito_user_pool.user_pool.id
}

# Output Cognito Client ID (needed on Lambdas as and EBV variable)
output "cognito_client_id" {
  value = aws_cognito_user_pool_client.cognito_appclient.id
}