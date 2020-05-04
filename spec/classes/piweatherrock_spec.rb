# frozen_string_literal: true

require 'spec_helper'

describe 'piweatherrock' do
  test_on = {
    hardwaremodels: [
      'armv6l',
      'armv7l',
      'i386',
      'x86_64',
    ],
  }

  on_supported_os(test_on).each do |os, os_facts|
    context "on #{os} (#{os_facts[:lsbdistid]})" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it {
        is_expected.to contain_systemd__unit_file('PiWeatherRock.service')
          .with_content(%r{/home/pi/PiWeatherRock/config.json})
      }
      it {
        is_expected.to contain_systemd__unit_file('PiWeatherRockConfig.service')
          .with_content(%r{/home/pi/PiWeatherRock/config.json})
      }
      it {
        is_expected.to contain_file('/home/pi/bin/xhost.sh')
          .with_content(%r{^xhost \+})
      }

      case os_facts[:lsbdistid]
      when 'Debian'
        it { is_expected.to contain_notify('Untested OS') }
      when 'Raspbian'
        it { is_expected.not_to contain_notify('Untested OS') }
      end

      case os_facts[:os]['hardware']
      when %r{^arm}
        it { is_expected.to contain_package('realvnc-vnc-server') }
        it { is_expected.to contain_service('vncserver-x11-serviced') }
      else
        it { is_expected.not_to contain_package('realvnc-vnc-server') }
        it { is_expected.not_to contain_service('vncserver-x11-serviced') }
      end
    end
  end
end
