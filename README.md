# soac-prototype
(A badly named repo which should have been soaRc)

## Actual services
The prototype consists of three different sub services. All of these are developed and delivered in small containerized node applications.

The `service-proxy` yields a simple redirect tool, which is used to direct users into the proper sub service layers. For now, this is simple part of the request, but would rather distribute based on users and IP addresses. Every request is forwarded to the endpoint given in the query `endpoint`. Here the ids should be the configured service names.

The `database-mock` is here limited to an AP endpoint which randomize data on startup using the path `/database`. This is done so to simplify the prototype. (Both in regards to communication, but also minimize differences in VMs chosen)

The `api-endpoint` then exposes the actual functionality of the api. Which here is simply forwarding the data from the database. (But not by exposing a proxy) This behavior is exposed on the path `/api-endpoint`.

All of these services can be build using the `build` script provided in the `services` folder. This uses two environment variables `DOCKER_USER` and `DOCKER_PASSWORD`. Using build, also automatically publish to docker hub, allowing them to be pulled elsewhere. They are released using their names prefixed with `soarc`. They are all also constructed to currently expose their services on port `9090`.

Regarding design of these services, the important part is that they all only interact with endpoints given through environment variables for them - here the proxy service is aware of the input format and there thereby exist a dependency in this case.

## Templates
Templates are the actual center of attention for the prototype. This is a system independent way of specifying and constructing VMs programmatically, so that we can automate deploy and construction of services. This part consists of a set of bash scripts that in combination with `vagrant` and the `worker` provides the basis for secure vm instantiation (building on ssh communication where environment variables secure transfer of keys)

- `deploy` is used to create the VMs and deploy them on the wanted provider.

- `install` allows you to install and run a given `docker image` on the specified vm.

- `fetch-ip` allows you to fetch a vm from a specific `worker`.

This system is made, so that all vms are tracked and stored in the `worker`. All execution and assignment is done through bash scripts, and environment variables.

The above scripts are used in the two primary scripts of the system. These are located outside the `templates` directory. These are:

- `configure` - this is the file in which the relation between the two services (`api-endpoint` and `database-mock`) is established. It is also here both of their associated VMs are set up, and the services installed and configured to use each other. In this script we also stores the produced service information in the `ips.conf` file which should exist and be located in the root folder. (The information is stored as a key value pair of the form: `serviceName=ip:port`. The endpoints which we are to use in the proxy service are prefixed with `>` to indicate that it is an access point)
- `startup` - is the primary file where we orchestrate the entirety of our system. We here also specify which `deploy-scheme` each "set of services" should be using (providing it to individual `configure`). These deploy-schemes decide on the params given to the vagrantfile, and also determines the specific vagrantfile used.

## The worker
The worker acts as the central unit which is utilised for initiating new VMs. This is done since most CI services do not allow direct integration with vagrant. This worker is therefore the central hub where vagrant files for the different VMs are constructed. The help commands all access this unit to then access the individual VMs. (except `install`). The worker, for now, therefore also contain all keys needed to access these. This setup, if time permitted it `install` could also be extended to go through the `worker`.

![architecture](/soac-prototype/architecture.png)
