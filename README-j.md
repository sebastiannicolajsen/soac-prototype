# Rationale

The need of horizontal scaling on different infraestructure lead us to explore tooling made on this regard.

# Description

For this prototype, we wanted to have a set of configurations that would allow us to have several instances deployed among different providers.

Because of familiarity, and being a reproducible system independent tool for setting up systems, we chosed Vagrant by Hashicorp.

## Vagrant. Basic concepts

The concept of *boxes* for Vagrant, allows the creation of identical environments for the different *providers* that Vagrant supports.

One can create their own Vagrant box with the specific needs we could have, and also configure it for the different providers. However, since we want to have a more general solution and not to modify the used boxes for every new provider, we opted to have basic deployment boxes for the different providers (for example dummy). And provision the systems with the needed dependencies through a Docker image on top.

This means we only use vagrant as a deploy tool for the different providers we may use.

## Vagrant as a deploy mechanism

To run this deployments as needed we need a process that has the knowledge of every created instance, together with other information, like the IP addresses of them, and such.

On this project, such a process in referred to as the **worker** and its meant to spawn and keep track of the online instances.

In this *worker* machine, the file `ips.conf` is used as storage for the deployed services. This machine will host each service and deploy it to the instances that need them, therefore we have to ensure that it has SSH access to them as seen on `deploy.sh`, or simply by preconfiguring this machine with a single key.

It's important to note that a breach on the worker would potentially comprise all the deployed systems, so extra care, or a different approach should be considered.

The *worker* will also set the different environment variables that may alter the behaviour of the instance of the application.

## Setting up AWS

To setup AWS for usage with this script you need to generate access keys for programmatic calls to the AWS API.

You can generate them under "Your Security Credentials" for your account settings.

After this, set them as the environment variables for the *worker*: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

To allow SSH access, you can manage it as any other server, however for the main user with sudo access, you need to specify a keypair to use. This can be configured under "EC2">"Key Pairs". 

After generating one, you should store it on the *worker* machine and set the path for it on the environment variable `AWS_KEY_PATH`, and the corresponding name of the keypair on `AWS_KEYPAIR_NAME`

Also to allow SSH access, you need to configure properly the firewall rules to allow inbound/outbound traffic. This rules should have the names `default`, `http-https`, and `basic-ssh-access` in agreement with `deploy-schemes/aws.conf`.

# Drawbacks of the chosen tools

Vagrant is meant to aid developers and test environments. It doesn't deal with orchestration of deploying to several environments. In this regard, we managed this with the scripts from this project.

Some team members experienced incompatibility issues for installing vagrant plugins with recent Vagrant versions. And different work arounds were needed to get plugin configurations working.

The reason for this is most likely that the plugins used are not officially mantained by Hashicorp, and proper updates rely on the maintenance of open source projects. So extra care should be taken if using this tool for production.


