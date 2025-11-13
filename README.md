# AWS-Security-Suite

A demonstration of deploying AWS security tooling using Terraform



# Assumptions

* You are familiar with AWS and the security tools and services they offer
* You are familiar with Terraform
* Im starting from scratch with a new AWS account. I manually set up the first root account and created a Terraform IAM user with full Admin permissions. Everything after this will be done through Terraform.



# Getting Started

If you have not already setup your root account do that. Go to [AWS](https://signin.aws.amazon.com/signup?request_type=register) and sign up for a new account. This will be your root account.

Next look in /Bootstrapper and follow the README found there to setup your terraform user and your first S3 bucket to store your state files in.