# soac-prototype
(A badly named repo which should have been soaRc)

## Actual services
The prototype consists of three different sub services. All of these are developed and delivered in small containerized node applications.

The `service-proxy` yields a simple redirect tool, which is used to direct users into the proper sub service layers. For now, this is simple part of the request, but would rather distribute based on users and IP addresses.

The `database-mock` is here limited to an AP endpoint which randomize data on startup. This is done so to simplify the prototype. (Both in regards to communication, but also minimize differences in VMs chosen)

The `api-endpoint` then exposes the actual functionality of the api. Which here is simply forwarding the data from the database. (But not by exposing a proxy)

All of these services can be build using the `build` script provided in the `services` folder. This uses two environment variables `DOCKER_USER` and `DOCKER_PASSWORD`. Using build, also automatically publish to docker hub, allowing them to be pulled elsewhere. They are released using their names prefixed with `soarc`.

Regarding design of these services, the important part is that they all only interact with endpoints given through environment variables for them.

## Templates
Templates are the actual center of attention for the prototype. This is a system independent way of specifying and constructing VMs programmatically, so that we can automate deploy and construction of services. This part consists of a set of bash scripts that in combination with `vagrant` and the `worker` provides the basis for secure vm instantiation (building on ssh communication where environment variables secure transfer of keys)

- `deploy` is used to create the VMs and deploy them on the wanted provider. This can be used by:

- `install` allows you to install and run a given `docker image` on the specified vm.

- `fetch-ip` allows you to fetch a vm from a specific `worker`.




## The worker
