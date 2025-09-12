#!/bin/bash

#set -x
set -e


echo "Enter the local AWS profile you want to use: "
read -r PROFILE

cd  iac/

terraform version

export AWS_PROFILE="${PROFILE}"

terraform  init

terraform  plan

wait

terraform  apply

rm -rf .terraform.lock.hcl
rm -rf .terraform/

echo ""
echo "If you do not plan on making any changes to these reources in the future you should delete the terraform.tfstate file found in /iac."
echo "Done...Goodbye"


exit 0