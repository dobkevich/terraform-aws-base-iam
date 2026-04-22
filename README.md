# Terraform Configuration for AWS IAM with OIDC Federation for GitHub Actions CI/CD

This repository provides a secure, production-ready AWS IAM configuration using Terraform. It implements modern security standards, including **OIDC Federation** for GitHub Actions, eliminating the need for long-lived static Access Keys.

## Features

-   **Secure CI/CD (Optional)**: Uses OpenID Connect (OIDC) to allow GitHub Actions to assume AWS roles dynamically.
-   **Admin Management**: Dedicated `aws_admin` user and `Admins` group with full `AdministratorAccess`.
-   **Billing Isolation**: Separate `BillingAdminRole` and group to delegate financial permissions securely.
-   **User Self-Management**: Pre-configured permissions for standard users to manage their own passwords, MFA, and access keys.
-   **Modular Design**: Clean separation of IAM concerns across specialized Terraform files.

## Project Structure

-   `iam_admin.tf`: Administrator user, group, and membership logic.
-   `iam_billing.tf`: Role and group for billing management.
-   `iam_standard_group.tf`: Policy for user self-service (MFA, passwords).
-   `iam_cicd.tf.template`: Template for OIDC Provider and Role for GitHub Actions.
-   `iam_outputs.tf`: Console login URLs and role ARNs.
-   `cicd_github_action.yaml`: A template for your GitHub Actions workflow.

## Prerequisites

1.  **AWS Account**: You need an active AWS account.
2.  **Terraform**: Version 1.0 or higher.
3.  **GitHub Repository**: (Optional) To host your CI/CD pipeline.

## Usage Guide

### 1. Basic Deployment
Initialize and apply the Terraform configuration to set up Admins, Billing, and Standard groups:

```bash
terraform init
terraform apply
```

Review the plan and type `yes` to confirm.

### 2. (Optional) Enable GitHub Actions CI/CD
If you want to use GitHub Actions with OIDC federation:

1. Rename the template file:
   ```bash
   mv iam_cicd.tf.template iam_cicd.tf
   ```
2. Edit `variables.tf` and update the `github_repository` variable with your repository path:
   ```hcl
   variable "github_repository" {
     default = "your-username/your-repo-name"
   }
   ```
3. Run `terraform apply` again to deploy the OIDC provider and role.

### 3. Retrieve Outputs
After deployment, Terraform will output the necessary information. If CI/CD is enabled, you will see the **Role ARN**:

```text
github_actions_role_arn = "arn:aws:iam::123456789012:role/GitHubActionsRole"
```

### 4. Setup GitHub Actions
Create a workflow in your repository (e.g., `.github/workflows/deploy.yml`) using the provided `cicd_github_action.yaml`. 

**Note:** Ensure you replace `YOUR_ACCOUNT_ID` in the workflow with your actual AWS Account ID.

## Security Notes

-   **MFA**: It is highly recommended to enable Multi-Factor Authentication for the `aws_admin` user immediately after the first login.
-   **Billing Access**: To enable the Billing Role, you must log in as the **Root User** once and enable "IAM User and Role Access to Billing" in the AWS Account Settings.
-   **Least Privilege**: The CI/CD role is currently assigned `AdministratorAccess`. For production environments, consider scoping this down to specific services.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
