# @summary Handles the installation steps for PiWeatherRock
#
# Handles the installation steps for PiWeatherRock
#
class piweatherrock::install {
  case $facts['kernel'] {
    'Linux': {
      $_main_packages = [
        'libgl1-mesa-dri',
        'lightdm',
        'x11-xserver-utils',
        'xserver-xorg',
      ]

      $_piweatherrock_packages = [
        'libjpeg-dev',
        'libportmidi-dev',
        'libsdl1.2-dev',
        'libsdl-image1.2-dev',
        'libsdl-mixer1.2-dev',
        'libsdl-ttf2.0-dev',
        'libtimedate-perl',
        'python3-pip',
      ]

      package { [ $_main_packages, $_piweatherrock_packages, ]:
        ensure          => latest,
        install_options => [
          '--no-install-recommends',
        ],
      }

      if $facts['os']['hardware'] =~ /^arm/ {
        package { 'realvnc-vnc-server':
          ensure          => latest,
          install_options => [
            '--no-install-recommends',
          ],
        }
      }

      if $piweatherrock::enable_awesome_desktop {
        package { [ 'awesome', 'lxterminal', ]:
          ensure          => latest,
          install_options => [
            '--no-install-recommends',
          ],
          before          => Package[$_piweatherrock_packages],
        }
      }

      python::pip { 'piweatherrock':
        ensure       => $piweatherrock::piweatherrock_version,
        pip_provider => 'pip3',
        require      => Package[
          $_main_packages,
          $_piweatherrock_packages,
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
