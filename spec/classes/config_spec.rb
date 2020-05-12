# frozen_string_literal: true

require 'spec_helper'

describe 'piweatherrock::config' do
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
      context 'with defaults' do
        let(:node) { 'mylittlepi.local' }
        let(:pre_condition) { 'include piweatherrock' }
        let(:facts) { os_facts }

        it { is_expected.to compile }

        it {
          is_expected.to contain_file('/home/pi/bin')
            .with_ensure('directory')
            .with_owner('pi')
            .with_group('pi')
        }

        it {
          is_expected.to contain_file('/home/pi/bin/xhost.sh')
            .with_content(%r{^xhost \+})
            .with_owner('pi')
            .with_group('pi')
        }

        it { is_expected.to contain_exec('enable display-setup-script') }

        it {
          is_expected.to contain_exec('import config')
            .with_user('pi')
            .with_command('pwr-config-upgrade -c /home/pi/piweatherrock-config.json -s /usr/local/lib/python3.7/dist-packages/piweatherrock/config.json-sample')
        }

        it {
          is_expected.to contain_systemd__unit_file('PiWeatherRock.service')
            .with_content(%r{/home/pi/piweatherrock-config.json})
        }

        it {
          is_expected.to contain_systemd__unit_file('PiWeatherRockConfig.service')
            .with_content(%r{/home/pi/piweatherrock-config.json})
        }
      end
    end
  end
end
