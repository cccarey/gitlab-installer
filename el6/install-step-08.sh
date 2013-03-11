#!/bin/bash
# Installer for GitLab on RHEL 6 (Red Hat Enterprise Linux and CentOS)
# mattias.ohlsson@inprose.com
#
# Only run this on a clean machine. I take no responsibility for anything.
#
# Submit issues here: github.com/mattias-ohlsson/gitlab-installer

echo "### Install GitLab"

# Download code
cd /var/www && git clone -b $GL_INSTALL_BRANCH https://github.com/gitlabhq/gitlabhq.git

# Install GitLab
cd $GL_INSTALL_ROOT && bundle install


