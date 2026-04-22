# Create aws_admin user
resource "aws_iam_user" "aws_admin" {
  name = "aws_admin"
  path = "/"

  tags = {
    Description = "Full Administrator User"
  }
}

# Console login profile with a temporary password
resource "aws_iam_user_login_profile" "aws_admin_login" {
  user                    = aws_iam_user.aws_admin.name
  password_reset_required = true
}

# Create Access Key for CLI access
#resource "aws_iam_access_key" "aws_admin_key" {
#  user = aws_iam_user.aws_admin.name
#}

# Administrators group
resource "aws_iam_group" "admins" {
  name = "Admins"
  path = "/"
}

# Attach AdministratorAccess managed policy to the Admins group
resource "aws_iam_group_policy_attachment" "admins_attach" {
  group      = aws_iam_group.admins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Add aws_admin user to the Admins and BillingAdmins groups
resource "aws_iam_user_group_membership" "admin_membership" {
  user = aws_iam_user.aws_admin.name

  groups = [
    aws_iam_group.admins.name,
    aws_iam_group.billing_admins.name # Group defined in iam_billing.tf
  ]
}
