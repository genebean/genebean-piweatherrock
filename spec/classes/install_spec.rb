# frozen_string_literal: true

require 'spec_helper'

describe 'piweatherrock::install' do
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

        [
          'libgl1-mesa-dri',
          'lightdm',
          'x11-xserver-utils',
          'xserver-xorg',
        ].each do |main_package|
          it { is_expected.to contain_package(main_package).with_ensure('latest') }
        end

        [
          'libjpeg-dev',
          'libportmidi-dev',
          'libsdl1.2-dev',
          'libsdl-image1.2-dev',
          'libsdl-mixer1.2-dev',
          'libsdl-ttf2.0-dev',
          'libtimedate-perl',
          'python3-pip',
        ].each do |piweatherrock_package|
          it { is_expected.to contain_package(piweatherrock_package).with_ensure('latest') }
        end

        case os_facts[:os]['hardware']
        when %r{^arm}
          it { is_expected.to contain_package('realvnc-vnc-server') }
        else
          it { is_expected.not_to contain_package('realvnc-vnc-server') }
        end

        it { is_expected.to contain_python__pip('piweatherrock') }
      end

      context 'with awesome desktop enabled' do
        let(:node) { 'mylittlepi.local' }
        let(:facts) { os_facts }

        let(:pre_condition) do
          '
          class { piweatherrock:
            enable_awesome_desktop => true,
          }'
        end

        it { is_expected.to compile }

        [
          'awesome',
          'lxterminal',
        ].each do |lite_package|
          it { is_expected.to contain_package(lite_package).with_ensure('latest') }
        end
      end
    end
  end
end
