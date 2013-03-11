#!/bin/bash
# Installer for GitLab on RHEL 6 (Red Hat Enterprise Linux and CentOS)
# mattias.ohlsson@inprose.com
#
# Only run this on a clean machine. I take no responsibility for anything.
#
# Submit issues here: github.com/mattias-ohlsson/gitlab-installer

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
MYSQL_ROOT_PW=$(cat /dev/urandom | tr -cd [:alnum:] | head -c ${1:-16})


die()
{
  # $1 - the exit code
  # $2 $... - the message string

  retcode=$1
  shift
  printf >&2 "%s\n" "$@"
  exit $retcode
}


echo "### Check OS (we check if the kernel release contains el6)"
uname -r | grep "el6" || die 1 "Not RHEL or CentOS"


echo "### Check if we are root"
[[ $EUID -eq 0 ]] || die 1 "This script must be run as root"


echo "### Configure SELinux"

# Disable SELinux
sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config

# Turn off SELinux in this session
setenforce 0


echo "### Installing packages"

# Install epel-release
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm

# Modified list from gitlabhq
yum install -y \
make \
libtool \
openssh-clients \
gcc \
libxml2 \
libxml2-devel \
libxslt \
libxslt-devel \
python-devel \
wget \
readline-devel \
ncurses-devel \
gdbm-devel \
glibc-devel \
tcl-devel \
openssl-devel \
db4-devel \
byacc \
httpd \
gcc-c++ \
curl-devel \
openssl-devel \
zlib-devel \
httpd-devel \
apr-devel \
apr-util-devel \
sqlite-devel \
libicu-devel \
gitolite \
git \
redis \
sudo \
mysql-devel \
postgresql-devel

