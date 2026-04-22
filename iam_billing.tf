# Role for Billing access
resource "aws_iam_role" "billing_admin_role" {
  name = "BillingAdminRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          # Allow all users in this account to assume the role 
          # (as long as they have explicit sts:AssumeRole permissions)
          # Alternatively, restrict to specific user ARNs for tighter security
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })
}

# Attach Billing managed policy to the role
resource "aws_iam_role_policy_attachment" "billing_policy_attach" {
  role       = aws_iam_role.billing_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}

# Group for Billing access
resource "aws_iam_group" "billing_admins" {
  name = "BillingAdmins"
  path = "/"
}

# Group policy allowing members to assume the BillingAdminRole
resource "aws_iam_group_policy" "allow_assume_billing_role_group" {
  name  = "AllowAssumeBillingRole"
  group = aws_iam_group.billing_admins.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.billing_admin_role.arn
      }
    ]
  })
}
