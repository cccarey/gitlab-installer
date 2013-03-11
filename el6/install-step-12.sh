#!/bin/bash
# Installer for GitLab on RHEL 6 (Red Hat Enterprise Linux and CentOS)
# mattias.ohlsson@inprose.com
#
# Only run this on a clean machine. I take no responsibility for anything.
#
# Submit issues here: github.com/mattias-ohlsson/gitlab-installer

echo "### Configure iptables"

# Open port 80
iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT

# Save iptables
service iptables save


