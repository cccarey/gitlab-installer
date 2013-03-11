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


echo "### Configure GitLab"

# Go to install root
cd $GL_INSTALL_ROOT

# Rename config files
cp config/gitlab.yml.example config/gitlab.yml

# Change gitlabhq hostname to GL_HOSTNAME
sed -i "s/  host: localhost/  host: $GL_HOSTNAME/g" config/gitlab.yml

# Change the from email address
sed -i "s/from: notify@localhost/from: notify@$GL_HOSTNAME/g" config/gitlab.yml

# Check database type
if [ "$GL_DATABASE_TYPE" = "sqlite" ]; then
  # Use SQLite
  echo "... using sqlite"
  cp config/database.yml.sqlite config/database.yml
else
  # Use MySQL
  echo "... using mysql"

  # Install mysql-server
  yum install -y mysql-server

  # Turn on autostart
  chkconfig mysqld on

  # Start mysqld
  service mysqld start

  # Copy congiguration
  cp config/database.yml.mysql config/database.yml

  # Set MySQL root password in configuration file
  sed -i "s/secure password/$MYSQL_ROOT_PW/g" config/database.yml

  # Set MySQL root password in MySQL
  echo "UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PW') WHERE User='root'; FLUSH PRIVILEGES;" | mysql -u root
fi

# Setup DB
rvm all do rake db:setup RAILS_ENV=production
rvm all do rake db:seed_fu RAILS_ENV=production

# Setup gitlab hooks
cp ./lib/hooks/post-receive /home/git/.gitolite/hooks/common/
chown git:git /home/git/.gitolite/hooks/common/post-receive


