# covalent-ssh-build-env

This repo gives a reproducible environment for running a Covalent workflow where some of the tasks are performed in a locally-hosted Docker container.

## Dependencies

* [Covalent](https://github.com/AgnostiqHQ/covalent)
* Python 3.8, 3.9 or 3.10 (this is tested with 3.10) 

### Remote systems

Here are a list of Operating Systems tested for the remote system

#### Working OS

* Ubuntu 22.04

#### **NOT** working OS

* Ubuntu 24.04

## Set up

### Python version

Check Python version

```
python --version
```

If not 3.8, 3.9 or 3.10, set up a local pyenv environment

```
pyenv install 3.10.13
pyenv local 3.10.13  
```

### Python virtual env

On first usage, create a python environment

```
python -m venv venv
```

Activate the environment

```
source venv/bin/activate 
```

### Install Covalent and Covalent-SSH-Plugin

```
pip install -r requirements.txt 
```

### Build the Docker host

Make your ssh key available to the Dockerfile, then build and run the container:

```
export MY_SSH_KEY="$(cat ~/path/to/<public_key>.pub)" 
docker build --build-arg MY_SSH_KEY="$MY_SSH_KEY" -t ssh_host .
```

Different Docker images can be build by passing the file argument, e.g.

```
docker build -f Dockerfile.python310slim --build-arg MY_SSH_KEY="$MY_SSH_KEY" -t ssh_host .
```

[Optional] To test the configuration, you should now be able to run the container and ssh into it:

```
docker run -it -d -p 2222:22 -it ssh_host 
ssh root@localhost -p 2222 
```

## Running

To run the test program, ensure the docker container is running, start the covalent server, and execute the test program:

```
docker run -it -d -p 2222:22 -it ssh_host 
covalent start
python quickstart.py
```

