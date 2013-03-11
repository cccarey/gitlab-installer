#!/bin/bash
# Installer for GitLab on RHEL 6 (Red Hat Enterprise Linux and CentOS)
# mattias.ohlsson@inprose.com
#
# Only run this on a clean machine. I take no responsibility for anything.
#
# Submit issues here: github.com/mattias-ohlsson/gitlab-installer

echo "### Install Passenger Apache module"

# Run the installer
rvm all do passenger-install-apache2-module -a


echo "### Start and configure redis"

# Start redis
/etc/init.d/redis start

# Automatically start redis
chkconfig redis on


