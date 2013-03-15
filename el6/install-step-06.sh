#!/bin/bash
# Installer for GitLab on RHEL 6 (Red Hat Enterprise Linux and CentOS)
# mattias.ohlsson@inprose.com
#
# Only run this on a clean machine. I take no responsibility for anything.
#
# Submit issues here: github.com/mattias-ohlsson/gitlab-installer

echo "### Installing RVM and Ruby"

# rvm requirements tell us to do this
yum install -y gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2

# Requirements for gem install capybara-webkit
# install devel packages for qt and qtwebkit
yum install qt-devel qtwebkit-devel -y
# add qmake to path
case $(uname -m) in
  x86_64) export PATH=$PATH:/usr/lib64/qt4/bin/ ;;
  *) export PATH=$PATH:/usr/lib/qt4/bin/ ;;
esac

# Instructions from https://rvm.io
curl -L get.rvm.io | bash -s stable

# Load RVM
source /etc/profile.d/rvm.sh

# Install Ruby (use command to force non-interactive mode)
command rvm install $RUBY_VERSION
#rvm use $RUBY_VERSION
rvm --default use $RUBY_VERSION

# Install core gems
gem install rails passenger rake bundler grit --no-rdoc --no-ri


