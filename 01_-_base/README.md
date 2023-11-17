# Base

This part of the codebase creates the following resources: 
- Google Cloud Project (if needed)
- Storage bucket to store Terraform state
- Necessary networking resources
- Cloud Source Repositories to store the codebase

# Run code

```shell
# Initialise Terraform code
terraform init -upgrade -reconfigure

# Create terraform.tfvars

# Apply Terraform code
terraform apply -auto-approve

# Re-init Terraform
terraform init

# Type 'yes' when it asks you to copy the state remotely

# Init git
git init ../ 

# Set the origin to the newly created 
$(terraform output -json | jq -r .git_repo_init_cmd.value) 

# Create the main branch
git checkout -b main 

# Add all files
git add --all 

# Commit files
git commit -m "Initial commit"

# Push to Cloud Source Repositories
git push --set-upstream origin main
```