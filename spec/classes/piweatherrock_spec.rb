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
      context 'with defaults' do
        let(:node) { 'mylittlepi.local' }
        let(:facts) { os_facts }

        it { is_expected.to compile }

        case os_facts[:lsbdistid]
        when 'Debian'
          it { is_expected.to contain_notify('Untested OS') }
        when 'Raspbian'
          it { is_expected.not_to contain_notify('Untested OS') }
        end
      end
    end
  end
end
