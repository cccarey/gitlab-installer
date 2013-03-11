#!/bin/bash
# Installer for GitLab on RHEL 6 (Red Hat Enterprise Linux and CentOS)
# mattias.ohlsson@inprose.com
#
# Only run this on a clean machine. I take no responsibility for anything.
#
# Submit issues here: github.com/mattias-ohlsson/gitlab-installer

echo "### Set up Gitolite"

# Run the installer as the git user
su - git -c "gl-setup -q /home/git/.ssh/id_rsa.pub"

# Change the umask (see the gitlab wiki)
sed -i 's/0077/0007/g' /home/git/.gitolite.rc

# Change permissions on repositories and home (group access)
chmod 750 /home/git
chmod 770 /home/git/repositories


