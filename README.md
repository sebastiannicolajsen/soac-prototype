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

configuration Google cloud provider - [link](https://gmusumeci.medium.com/getting-started-with-terraform-and-google-cloud-platform-gcp-e718017376d1) 


### Required environment variables

To use AWS provider:

- `AWS_ACCESS_KEY_ID`  

- `AWS_SECRET_ACCESS_KEY`
- `TF_VAR_AWS_KEY_LOCATION`

It may also be necessary to  change the user within the different providers of the setup folder (i.e. the default user `ec2-user` for aws might not be applicable in your case if you changed the user name). Additionally, you may also need to change the `key_name` in the provider (currently set to `terraform2`)

To use Google provider:

- `TF_VAR_GOOGLE_CRED_LOCATION` - the json file download after following the tutorial
- `TF_VAR_GOOGLE_SEC_KEY_LOCATION ` - this isn't created at google, you provide it. 
- `TF_VAR_GOOGLE_PUB_KEY_LOCATION ` - this isn't created at google, you provide it.  (relate to the above key)



### Guide to running

terraform init && terraform apply.

Also, do be aware of the Google cloud settings as their services are extremely slow compared to AWS (5x-10x startup time, haven't been able to find a good setup that is free yet. This also means that the current settings require enabled billing, and is still slow). Also for some reason ssh'ing into the box is performing better.

I also began having trouble with the aws VMs at some point, failing in irregular patterns when completely reinstalling. But the state handling / ability to deploy specific parts (and remaining dependencies) makes this rather easy to over come. But it has not been 1 step solves it all. 

### Development comments
some of the terraform modules are developed using symlinks to enable reuse.

Far from all things have been collected and abstracted out of all files.