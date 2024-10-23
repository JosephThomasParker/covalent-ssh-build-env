# Download base image ubuntu 22.04
FROM ubuntu:22.04
LABEL maintainer="joseph.parker@ichec.ie"
LABEL version="1.0.0"
LABEL description="Image for testing software that connects via ssh"

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive


RUN apt update \ 
	&& apt install -y \
	git \
	vim \
	rsync \
	curl

# Install SSH server
RUN apt-get update && apt-get install -y openssh-server

RUN apt install -y \
	python3 \
	python3-pip

RUN pip3 install covalent covalent-ssh-plugin

# Create privilege separation directory
RUN mkdir /run/sshd

# Copy SSH key for authentication
ARG MY_SSH_KEY

# Create the .ssh directory and copy SSH key for authentication
RUN mkdir -p /root/.ssh \
    && echo "$MY_SSH_KEY" > /root/.ssh/authorized_keys \
    && chmod 700 /root/.ssh \
    && chmod 600 /root/.ssh/authorized_keys

RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's@session    required   pam_loginuid.so@session    optional   pam_loginuid.so@g' /etc/pam.d/sshd

RUN sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
# Expose port 22
EXPOSE 22

# Start SSH server
CMD ["/usr/sbin/sshd", "-D", "-e"]
