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


```