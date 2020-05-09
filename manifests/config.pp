# @summary Handles the configuration steps for PiWeatherRock
#
# Handles the configuration steps for PiWeatherRock
#
class piweatherrock::config {
  case $facts['kernel'] {
    'Linux': {
      # allow all sessions to share the X server
      # see https://www.computerhope.com/unix/xhost.htm
      file {
        default:
          owner => $piweatherrock::user,
          group => $piweatherrock::group,
          mode  => '0755',
        ;
        "/home/${piweatherrock::user}/bin":
          ensure => directory,
        ;
        "/home/${piweatherrock::user}/bin/xhost.sh":
          ensure  => file,
          content => @(END),
            #!/bin/bash
            xhost +
            | END
        ;
      }

      # make lightdm use the xhost settings above
      exec { 'enable display-setup-script':
        path    => '/bin:/usr/bin',
        command => "sed -i 's|#display-setup-script=|display-setup-script=/home/pi/bin/xhost.sh|' /etc/lightdm/lightdm.conf",
        unless  => "grep -e '^display-setup-script' /etc/lightdm/lightdm.conf",
        require => Package['lightdm'],
      }

      # Run upgrade script to import current config values to new config file
      exec { 'import config':
        user        => $piweatherrock::user,
        path        => '/bin:/usr/bin:/usr/local/bin',
        command     => "pwr-config-upgrade -c ${piweatherrock::config_file} -s ${piweatherrock::sample_config_file}",
        refreshonly => true,
        subscribe   => Python::Pip['piweatherrock'],
        notify      => [
          Service['PiWeatherRock.service'],
          Service['PiWeatherRockConfig.service'],
        ],
      }
    }
    'Darwin': {
      notify { 'Coming soon':
        message => 'macOS support is coming soon',
      }
    }
    default: {
      fail("${facts['kernel']} is not supported. PR's welcome though.")
    }
  }
}
