# soac-prototype
(A badly named repo which should have been soaRc)



#### Prerequisites

- Install terraform - https://learn.hashicorp.com/tutorials/terraform/install-cli
- Install ansible - https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

### Tutorials followed

Initial AWS instance setup - [link](https://learn.hashicorp.com/tutorials/terraform/aws-build?in=terraform/aws-get-started)

Configuration of AWS provider - [link](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

Inputting variables - [link](https://learn.hashicorp.com/tutorials/terraform/aws-variables?in=terraform/aws-get-started)

Github repo for ansible and terraform integration - [link](https://github.com/scarolan/ansible-terraform)

To create modules - [link](https://www.terraform.io/docs/language/modules/develop/index.html)

creating outputs - [link](https://www.terraform.io/docs/cli/commands/output.html)

creating proper AWS networks - [link](https://towardsdatascience.com/connecting-to-an-ec2-instance-in-a-private-subnet-on-aws-38a3b86f58fb)



### Required environment variables

To use AWS provider:

- `AWS_ACCESS_KEY_ID`  

- `AWS_SECRET_ACCESS_KEY`
- `TF_VAR_AWS_KEY_LOCATION`





### Guide to running

We set terraform variables like this:

