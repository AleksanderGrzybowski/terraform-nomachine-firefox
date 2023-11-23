# Private remote browser in AWS

## What is this?

This Terraform setup can be used to create a secure and private browsing experience, for situations where certain websites are blocked at network level or could contain harmful scripts.

## How it works?

This setup consists of:

* AWS VPC and required network resources to run a remote desktop environment, provisioned by Terraform,
* EC2 Ubuntu instance with password login (no keys required),
* graphical Xubuntu environment with Firefox, Google Chrome and other extras, provisioned by Ansible,
* NoMachine remote desktop service.

## How to run it?

Run `terraform apply`, then connect with NoMachine client (user `ubuntu`, port 4000) using public IP printed back at the end. Everything will be provisioned at runtime for cost saving. To remove everything, run `terraform destroy`.

![Screenshot 1](screenshot.png)
