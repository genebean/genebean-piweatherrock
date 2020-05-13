# @summary Installs and configures PiWeatherRock
#
# Installs and configures PiWeatherRock
#
# @example Defaults
#   include piweatherrock
#
# @example Use an alternate config file
#   class { 'piweatherrock':
#     config_file => '/home/pi/piweatherrock.json',
#   }
#
# @param [Boolean] enable_awesome_desktop
#   If using Raspbian Lite you may want to enable this so that you have a lite
#   weight desktop and terminal
#
# @param [Stdlib::Unixpath] config_file
#   The path to the config file for PiWeatherRock
#
# @param [Stdlib::Unixpath] sample_config_file
#   The path to the sample config file that is bundled with PiWeatherRock
#
# @param [String[1]] piweatherrock_version
#    The version of piweatherrock to install from PyPI
#
# @param [String[1]] user
#    The user who PiWeatherRock will run as
#
# @param [String[1]] group
#    The group of the user who PiWeatherRock will run as.
#
class piweatherrock (
  Boolean $enable_awesome_desktop = false,
  Stdlib::Unixpath $config_file = '/home/pi/piweatherrock-config.json',
  Stdlib::Unixpath $sample_config_file = '/usr/local/lib/python3.7/dist-packages/piweatherrock/config.json-sample',
  String[1] $piweatherrock_version = '2.0.1',
  String[1] $user = 'pi',
  String[1] $group = 'pi',
) {
  if $facts['kernel'] {
    # post notice if not Raspbian 10 or newer
    unless ($facts['os']['name'] == 'Debian') and
      ($facts['os']['distro']['id'] == 'Raspbian') and
      (versioncmp($facts['os']['release']['major'], '10') == 0) {
        notify {'Untested OS':
          message => 'This manifest has only been tested Raspbian 10 (buster)',
          before  => Class['piweatherrock::install'],
        }
    }
  }

  contain piweatherrock::install
  contain piweatherrock::config
  contain piweatherrock::service

  Class['piweatherrock::install']
  -> Class['piweatherrock::config']
  -> Class['piweatherrock::service']
}
