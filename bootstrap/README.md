# Demo Bootstrap

This directory contains:

- Source code for two demo applications
- A [Justfile](https://just.systems/man/en/) containing the commands for setting up a demo environment
- A [Kind](https://kind.sigs.k8s.io/) configuration file

The use of Just is optional. However, there are a couple of assumptions about your system.

## Assumptions

- Docker is installed and running
- Kind is installed

## Init

To set up everything you need for the purposes of following through the tutorial you can do one of two things.

If you have Just installed, navigate to this `bootstrap/` directory and smash the following keys into your terminal:

```sh
just init
```

If you don't have Just installed (or my file doesn't work because you're on Windows), you can run the following commands from this `bootstrap/` directory, **in this order**:

```sh
kind create cluster --config kind.yaml
kubectl apply -f https://kind.sigs.k8s.io/examples/ingress/deploy-ingress-nginx.yaml

docker build -f apps/a/Dockerfile -t docker.io/library/micro-a:0.0.1 apps/a
docker build -f apps/b/Dockerfile -t docker.io/library/micro-b:0.0.1 apps/b
docker pull alpine:latest
kind load docker-image -n crash docker.io/library/micro-a:0.0.1
kind load docker-image -n crash docker.io/library/micro-b:0.0.1
kind load docker-image -n crash docker.io/library/alpine:latest

docker exec -it crash-control-plane crictl images
```

## Destruction

To clean everything up, you can use one of the two following commands:

```sh
just destroy
```

```sh
kind delete cluster -n crash
```
