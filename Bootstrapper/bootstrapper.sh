#!/bin/bash

#set -x
set -e


echo "Enter the local AWS profile you want to use: "
read -r PROFILE

cd  iac/

terraform version

export AWS_PROFILE="${PROFILE}"
export TF_VAR_profile="${PROFILE}"

terraform  init

terraform  apply

rm -rf .terraform.lock.hcl
rm -rf .terraform/

echo ""
echo "✅ Bootstrapper has finished creating the necessary resources to store your terraform state file in a secure manner."
echo ""
echo "Run the following command to retrieve the AWS Secret Key for the Terraform user you just created."
echo "terraform init && terraform state pull | jq -r '.outputs.aws_iam_user_access_terraform.value'"
echo ""
echo "If you do not plan on making any changes to these reources in the future you should delete the terraform.tfstate file or move it to a more secure place like your new S3 bucket you just created."
echo "Done...Goodbye 👋"


exit 0