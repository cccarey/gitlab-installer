#!/bin/bash
# Installer for GitLab on RHEL 6 (Red Hat Enterprise Linux and CentOS)
# mattias.ohlsson@inprose.com
#
# Only run this on a clean machine. I take no responsibility for anything.
#
# Submit issues here: github.com/mattias-ohlsson/gitlab-installer

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


