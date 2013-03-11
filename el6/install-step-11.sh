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


echo "### Configure Apache"

# Get the passenger version
export PASSENGER_VERSION=`find /usr/local/rvm/gems/$RUBY_VERSION/gems -type d -name "passenger*" | cut -d '-' -f 4`

# Create a config file for gitlab
cat > /etc/httpd/conf.d/gitlabhq.conf << EOF
<VirtualHost *:80>
    ServerName $GL_HOSTNAME
    DocumentRoot $GL_INSTALL_ROOT/public
    LoadModule passenger_module /usr/local/rvm/gems/$RUBY_VERSION/gems/passenger-$PASSENGER_VERSION/ext/apache2/mod_passenger.so
    PassengerRoot /usr/local/rvm/gems/$RUBY_VERSION/gems/passenger-$PASSENGER_VERSION
    PassengerRuby /usr/local/rvm/wrappers/$RUBY_VERSION/ruby
    <Directory $GL_INSTALL_ROOT/public>
        AllowOverride all
        Options -MultiViews
    </Directory>
</VirtualHost>
EOF

# Enable virtual hosts in httpd
cat > /etc/httpd/conf.d/enable-virtual-hosts.conf << EOF
NameVirtualHost *:80
EOF

# Ensure that apache owns all of gitlabhq
chown -R apache:apache $GL_INSTALL_ROOT

# Apache needs access to gems (?)
chown apache:root -R /usr/local/rvm/gems/


