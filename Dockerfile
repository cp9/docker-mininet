FROM debian:wheezy

MAINTAINER cp9 <lichandler116@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ENV MININET_REPO https://github.com/mininet/mininet.git
ENV MININET_INSTALLER mininet/util/install.sh
ENV INSTALLER_SWITCHES -fbinptvwyx

WORKDIR /tmp

# Update and install minimal.
RUN \
    apt-get update \
        --quiet \
    && apt-get install \
        --yes \
        --no-install-recommends \
        --no-install-suggests \
    autoconf \
    automake \
    ca-certificates \
    git \
    libtool \
    net-tools \
    openssh-client \
    openssh-server \
    patch \
    vim \

# Clone and install.
    && git clone $MININET_REPO \

# A few changes to make the install script behave.
    && sed -e 's/sudo //g' \
    	-e 's/~\//\//g' \
    	-e 's/\(apt-get -y install\)/\1 --no-install-recommends --no-install-suggests/g' \
    	-i $MININET_INSTALLER \

# Install script expects to find this. Easier than patching that part of the script.
    && touch /.bashrc \

# Proceed with the install.
    && chmod +x $MININET_INSTALLER \
    && ./$MININET_INSTALLER -nfv \

# Clean up source.
    && rm -rf /tmp/mininet \
              /tmp/openflow \

# Clean up packages.
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set ssh server
    RUN mkdir /var/run/sshd
    RUN echo 'root:root' | chpasswd
    RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
    ENV NOTVISIBLE "in users profile"
    RUN echo "export VISIBLE=now" >> /etc/profile


VOLUME ["/data"]

WORKDIR /data

# Default command.
CMD service openvswitch-switch start && bash
