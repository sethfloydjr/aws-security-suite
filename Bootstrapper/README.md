# BootStrapper

## Summary

The bootstrapper script should be run to setup a IAM (terraform) user in a new AWS account that you want to then run Terraform in.

## Usage

* Create your root/main account in AWS. 
* Temporarily give your root user AWS Access Keys. 
* Run `aws configure` to setup your root user access keys locally. When you run the Bootstrapper script you will be asked for the name of the profile you created locally.

Using the AWS profile of your root user, the script will create the IAM (terraform) user. The script will also create a bucket to store your future statefiles in along with another bucket that will be in a different region that the statefiles will replicate to. The AWS Secret Key for your new terraform user will be available after the script has successfully applied all of the terraform.

Although the script does clean up after itself somewhat it does not delete the local statefile that is created. You should move and store this file someplace safe or if you plan to never alter the created resources you can simply delete the statefile.

## Mentions

Before you run this script it is assumed that you have created an AWS account along with the root users AWS keys and have set those keys up locally in a profile. This script will then use the permissions of the root user to create the bucket and the terraform user along with admin permissions.

* DO NOT forget to delete the root user AWS keys after you have completed this script and are satisfied with the results.

* You will be asked for the `project` name. This will be the prefix that is given to your buckets that are created by the script. It is recommended to stick with this project name for the rest of your resources and bucket names.
