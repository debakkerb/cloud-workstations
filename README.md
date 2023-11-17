# Cloud Workstations

The purpose of this repository is to demonstrate Cloud Workstations.  The code creates the following resources:
- Enables the necessary APIs
- Create a Cloud Source Repository to host the code.
- A Cloud Build trigger to create the Workstation images.
- A Cloud Build trigger to create the Terraform code.
- A Schedule that recreates the Cloud Workstation images on a nightly basis.
- A Workstation cluster
- A Workstation configuration
- A Workstation with Intellij

# Install

Run the following script to create everything in a Google Cloud project you manage.

## Setup codebase and local environment

```shell
# Ensure you are logged in with your Cloud Identity
gcloud auth login
gcloud auth application-default login

# Clone the repository and remove the .git files
git clone https://github.com/debakkerb/cloud-workstations.git && cd cloud-workstations 

# Store the current directory in a variable
PARENT_DIR=$(pwd)

# Remove the .git folder, as we are going to create a Cloud Source Repository for this code
rm -rf .git
```

## Terraform code

In this section, you will create a `terraform.tfvars`-file in the [01_-_base](./01_-_base)-directory.  Make sure to update `<PROJECT_ID>` and `<CREATE_PROJECT>` first, before you hit enter.

```shell
# Move to the correct folder
cd 01_-_base

# Create terraform.tfvars file with the necessary variables for the base-folder
cat >> $PARENT_DIR/01_-_base/terraform.tfvars <<EOL
project_id     = "<PROJECT_ID>"
create_project = <CREATE_PROJECT>
admin_user     = "$(gcloud config list --format json | jq -r .core.account)"
EOL

# Initialise Terraform
terraform init -upgrade -reconfigure

# Apply the changes
terraform apply -auto-approve

# Init terraform again and type 'yes' when the system asks you to copy the state remotely
terraform init
```

## Git 

We've now created a Google Cloud project with all necessary resources to start creating the Workstation cluster, config and images.  As we are using Cloud Build and Cloud Build points to Cloud Source Repositories, we need to reinitialise Git

Currently, all `backend.tf`-files are ignored.  They contain the configuration for the Storage buckets to store the Terraform state files.  When you're working with a private repository and you control who has access to it, you can remove them from .gitignore and store them in Git as well.  This will allow you to work on the same state from different locations and with different users. 

```shell
# Initialise a new Git repository
git init $PARENT_DIR

# Set Origin
$(terraform output -json | jq -r .git_repo_init_cmd.value)

# Set the branch to main
git checkout -b main

# [OPTIONAL] Remove backend.tf files from .gitignore
sed -i '/backend.tf/d' $PARENT_DIR/.gitignore

# Add all files and commit them
git add --all && git commit -m "Initial setup"

# Push local changes
git push --set-upstream origin main
```

## Workstation Preparation 

In this part, we'll create an Artifact Registry repository and create the base images for both OSS and Intellij workstations.

```shell
# Switch to the correct directory
cd $PARENT_DIR/02_-_workstation_base

# Apply the Terraform changes
terraform init -upgrade -reconfigure
terraform apply -auto-approve
```

## Workstations

In this section, we will create the workstation for your personal use

