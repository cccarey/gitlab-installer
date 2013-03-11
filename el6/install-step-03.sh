#!/bin/bash
# Installer for GitLab on RHEL 6 (Red Hat Enterprise Linux and CentOS)
# mattias.ohlsson@inprose.com
#
# Only run this on a clean machine. I take no responsibility for anything.
#
# Submit issues here: github.com/mattias-ohlsson/gitlab-installer

echo "### Create the git user and keys"

# Create the git user
/usr/sbin/adduser -r -m --shell /bin/bash --comment 'git version control' git

# Create keys as the git user
su - git -c 'ssh-keygen -q -N "" -t rsa -f ~/.ssh/id_rsa'


