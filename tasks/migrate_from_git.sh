#!/usr/bin/env bash
# Puppet Task Name: migrate_from_git

set -e

if [[ $(id -u) -ne 0 ]]; then
  echo "{ \"_error\": {
    \"msg\": \"Please add '--run-as root' to your bolt command\",
    \"kind\": \"puppetlabs.tasks/task-error\",
    \"details\": { \"exitcode\": 1 }
  }"
  exit 1
fi

# make sure the old version of epel isn't installed
rm -rf /etc/puppet/code/modules/epel

# Install this puppet module on the Pi
puppet module install genebean-piweatherrock

# Migrate the old config file and set permissions on it
if [[ -f '/home/pi/PiWeatherRock/config.json' ]]; then
  # this is the most recent version of the config that was used with the non-PyPI version of PiWeatherRock
  puppet resource file '/home/pi/piweatherrock-config.json' ensure='file' owner='pi' group='pi' mode='0644' source='/home/pi/PiWeatherRock/config.json'
elif [[ -f '/home/pi/PiWeatherRock/config.py' ]]; then
  # this is the original version of the config that was used with the non-PyPI version of PiWeatherRock
  puppet resource file '/home/pi/config.py' ensure='file' owner='pi' group='pi' mode='0644' source='/home/pi/PiWeatherRock/config.py'
else
  echo "{ \"_error\": {
    \"msg\": \"Unable to find an old config file at either '/home/pi/PiWeatherRock/config.json' or '/home/pi/PiWeatherRock/config.py'\",
    \"kind\": \"puppetlabs.tasks/task-error\",
    \"details\": { \"exitcode\": 2 }
  }"
  exit 2
fi

# Setup PiWeatherRock itself
puppet apply -e 'include piweatherrock'
