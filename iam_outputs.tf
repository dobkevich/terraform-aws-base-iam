data "aws_caller_identity" "current" {}

output "console_login_url" {
  value = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
}

output "aws_admin_console_password" {
  value     = aws_iam_user_login_profile.aws_admin_login.password
  sensitive = true
}

#output "aws_admin_access_key_id" {
#  value     = aws_iam_access_key.aws_admin_key.id
#  sensitive = true
#}

#output "aws_admin_secret_access_key" {
#  value     = aws_iam_access_key.aws_admin_key.secret
#  sensitive = true
#}

output "billing_role_arn" {
  value = aws_iam_role.billing_admin_role.arn
}

output "instructions" {
  value = <<-EOT
    1. Use 'console_login_url' to log in as 'aws_admin'.
    2. Change the temporary password on first login.
    3. IMPORTANT: To enable billing access, log in as 'root' and enable
       'IAM User and Role Access to Billing' in Account Settings.
  EOT
}
