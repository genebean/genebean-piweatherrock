# @summary Manages services associated with PiWeatherRock
#
# Manages services associated with PiWeatherRock
#
class piweatherrock::service {
  case $facts['kernel'] {
    'Linux': {
      systemd::unit_file { 'PiWeatherRock.service':
        content => epp('piweatherrock/PiWeatherRock.service.epp', {
          'config_file' => $piweatherrock::config_file,
        }),
        require => Python::Pip['piweatherrock'],
        notify  => Service['PiWeatherRock.service'],
      }

      service {'PiWeatherRock.service':
        ensure    => running,
        enable    => true,
        require   => Systemd::Unit_file['PiWeatherRock.service'],
        subscribe => [
          Exec['enable display-setup-script'],
          File['/home/pi/bin/xhost.sh'],
          Python::Pip['piweatherrock'],
        ],
      }

      systemd::unit_file { 'PiWeatherRockConfig.service':
        content => epp('piweatherrock/PiWeatherRockConfig.service.epp', {
          'config_file' => $piweatherrock::config_file,
        }),
        require => Python::Pip['piweatherrock'],
        notify  => Service['PiWeatherRockConfig.service'],
      }

      service {'PiWeatherRockConfig.service':
        ensure    => running,
        enable    => true,
        require   => Systemd::Unit_file['PiWeatherRockConfig.service'],
        subscribe => [
          Exec['enable display-setup-script'],
          File['/home/pi/bin/xhost.sh'],
          Python::Pip['piweatherrock'],
        ],
      }

      if $facts['os']['hardware'] =~ /^arm/ {
        service { 'vncserver-x11-serviced':
          ensure  => running,
          enable  => true,
          require => Package['realvnc-vnc-server'],
        }
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
