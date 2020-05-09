# frozen_string_literal: true

require 'spec_helper'

describe 'piweatherrock::service' do
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

        it { is_expected.to contain_service('PiWeatherRock.service') }
        it { is_expected.to contain_service('PiWeatherRockConfig.service') }

        case os_facts[:os]['hardware']
        when %r{^arm}
          it { is_expected.to contain_service('vncserver-x11-serviced') }
        else
          it { is_expected.not_to contain_service('vncserver-x11-serviced') }
        end
      end
    end
  end
end
