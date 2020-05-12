#!/usr/bin/env bash
# Puppet Task Name: pisetup

set -e

NAME=$PT_name
TIMEZONE=$PT_timezone

if [[ $(id -u) -ne 0 ]]; then
  echo "{ \"_error\": {
    \"msg\": \"Please add '--run-as root' to your bolt command\",
    \"kind\": \"puppetlabs.tasks/task-error\",
    \"details\": { \"exitcode\": 1 }
  }"
  exit 1
fi

# set the timezone
timedatectl set-timezone ${TIMEZONE}

# patch the system and do setup
apt-get update -qq
apt-get full-upgrade -y
apt-get install -y puppet
rm -f /etc/puppet/hiera.yaml

# update the hostname
hostnamectl set-hostname $NAME
puppet resource host raspberrypi ensure=absent target='/etc/hosts'
puppet resource host ${NAME} ensure=present ip='127.0.0.1' target='/etc/hosts'

# make sure the old version of epel isn't installed
rm -rf /etc/puppet/code/modules/epel

# Install this puppet module on the Pi
puppet module install genebean-piweatherrock

# Setup PiWeatherRock itself
if [ "${PT_awesomewm}" == 'true' ]; then
  puppet apply -e "class { 'piweatherrock': enable_awesome_desktop => true, }"
else
  puppet apply -e 'include piweatherrock'
fi
