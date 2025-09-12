# BootStrapper

## Summary

The bootstrapper script should be run to setup a IAC IAM user in a new AWS account that you want to then run Terraform or OpenTofu IAC in.

Using the AWS profile of your root user, the script will create the IAC IAM user and place it in a group that has Administrator access to the account. The script will also create a bucket to store your future statefiles in along with another bucket that will be in a different region that the statefiles will replicate to. The AWS Access Keys and Secret Keys are generated and given in the final output of the scripts run.

Although the script does clean up after itself somewhat it does not delete the local statefile that is created for the resources created in the scripts run. You should move and store this file to someplace safe or if you plan to never alter the created resources you can simply delete the statefile.

## Mentions

* Before you run this script it is assumed that you have created an AWS account along with the root users AWS keys and have set those keys up locally in a profile. You will notice there is no configuration for the keys in the IAC code. In order to use this code and execute it you should do `export AWS_PROFILE="name_of_your_root_profile"`. This will then use the permissions of the root user to create the bucket and the IAM user along with associated group and permissions.

* DO NOT forget to delete the root user AWS keys after you have completed this script and are satisfied with the results.

* You will be asked for the `project` name. This will be the prefix that is given to your buckets that are created by the script. It is recommended to stick with this project name for the rest of your resources and bucket names.
