#!/bin/bash
# Installer for GitLab on RHEL 6 (Red Hat Enterprise Linux and CentOS)
# mattias.ohlsson@inprose.com
#
# Only run this on a clean machine. I take no responsibility for anything.
#
# Submit issues here: github.com/mattias-ohlsson/gitlab-installer

echo "### Start Apache"

# Start on boot
chkconfig httpd on

# Start Apache
service httpd start

# getting error
# Cannot load /usr/local/rvm/gems/ruby-1.9.3-p327/gems/passenger-3.0.19/ext/apache2/mod_passenger.so into server
# "failed to map segment from shared object" on
# see https://groups.google.com/forum/?fromgroups=#!topic/phusion-passenger/_pAIvpeWVfU

echo "### Done ###"
echo "#"
if [ "$GL_DATABASE_TYPE" != "sqlite" ]; then
  # Print MySQL root password instructions
  echo "# You have your MySQL root password in this file:"
  echo "# $GL_INSTALL_ROOT/config/database.yml"
  echo "#"
fi
echo "# Point your browser to:"
echo "# http://$GL_HOSTNAME (or: http://<host-ip>)"
echo "# Default admin username: admin@local.host"
echo "# Default admin password: 5iveL!fe"
echo "#"
echo "# Flattr me if you like this! https://flattr.com/profile/mattiasohlsson"
echo "###"
