#!/bin/bash

BASE_URL="https://raw.github.com/cccarey/gitlab-installer/stepped_install"
VERSION="el6"

parts=13
current=1

if [ ! -z "$1" ]; then
    current="$1"
fi

if [ ! -z "$2" ]; then
    parts="$2"
fi

while [ $current -le $parts ]; do
    url="$BASE_URL/$VERSION/install-step-`printf "%02d" $current`.sh"
    wget $url
    current=$(( $current + 1 ))
done

current=1
while [ $current -le $parts ]; do
    source install-step-`printf "%02d" $current`.sh
done
