#!/bin/bash

die()
{
  # $1 - the exit code
  # $2 $... - the message string

  retcode=$1
  shift
  printf >&2 "%s\n" "$@"
  exit $retcode
}

BASE_URL="https://raw.github.com/cccarey/gitlab-installer/stepped_install"
VERSION="el6"

parts=13
start=1

if [ ! -z "$1" ]; then
    start="$1"
fi

current=$start

if [ ! -z "$2" ]; then
    parts="$2"
fi

while [ $current -le $parts ]; do
    url="$BASE_URL/$VERSION/install-step-`printf "%02d" $current`.sh"
    wget $url
    current=$(( $current + 1 ))
done

# Exit on error
set -e

# Define the database type (sqlite or mysql (default))
export GL_DATABASE_TYPE=mysql

# Define the public hostname
export GL_HOSTNAME=$HOSTNAME

# Define gitlab installation root
export GL_INSTALL_ROOT=/var/www/gitlabhq

# Install from this GitLab branch
export GL_INSTALL_BRANCH=stable

# Define the version of ruby the environment that we are installing for
export RUBY_VERSION=ruby-1.9.3-p327

# Define the rails environment that we are installing for
export RAILS_ENV=production

# Define MySQL root password (we need it if we want mysql)
export MYSQL_ROOT_PW=$(cat /dev/urandom | tr -cd [:alnum:] | head -c ${1:-16})

echo "### Check OS (we check if the kernel release contains el6)"
uname -r | grep "el6" || die 1 "Not RHEL or CentOS"


echo "### Check if we are root"
[[ $EUID -eq 0 ]] || die 1 "This script must be run as root"


echo "### Configure SELinux"

# Disable SELinux
sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config

# Turn off SELinux in this session
setenforce 0


current=$start
while [ $current -le $parts ]; do
    source install-step-`printf "%02d" $current`.sh
    current=$(( $current + 1 ))
done
