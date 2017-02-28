#!/bin/bash
# 
# dockerのインストール
# ===================

if [ -e /etc/redhat-release ]; then
  mver=`cat /etc/redhat-release | awk "{print \\$3}" | sed -e 's/\\..*//'`
  if [ "$mver" = "release" ]; then
    mver=`cat /etc/redhat-release | awk "{print \\$4}" | sed -e 's/\\..*//'`
  fi

  if [ "$mver" = "6" ]; then
    rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    yum install -y docker-io
    chkconfig docker on
    service docker startrant
  elif [ "$mver" = "7" ]; then
    yum install -y docker
    systemctl enable docker
    systemctl start docker
    usermod -aG dockerroot vagrant
  else
    echo "not implemented! [$mver]" 1>&2
    exit 1
  fi
elif [ -e /etc/lsb-release ]; then
  . /etc/lsb-release
  # Install Docker
  if [ "$DISTRIB_CODENAME" = "trusty" ]; then
    # Recommended extra packages for Trusty
    apt-get install -y --no-install-recommends \
      linux-image-extra-$(uname -r) \
      linux-image-extra-virtual
  fi
  if [ "$DISTRIB_CODENAME" = "trusty" -o "$DISTRIB_CODENAME" = "xenial" ]; then
    apt-get install -y --no-install-recommends \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common
    curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
    apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D
    add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"
    apt-get update
    apt-get -y install docker-engine=1.13.1-0~ubuntu-$(lsb_release -cs)
  else
    echo "not implemented! [$DISTRIB_CODENAME]" 1>&2
    exit 1
  fi
  # Manage Docker as a non-root user
  # Configure Docker to start on boot
  if [ "$DISTRIB_CODENAME" = "xenial" ]; then
    # systemd
    systemctl enable docker
    systemctl start docker
  else
    # upstart
    echo manual | tee /etc/init/docker.override
    chkconfig docker on
  fi
else
  echo 'not implemented! [unknown OS]' 1>&2
  exit 1
fi
