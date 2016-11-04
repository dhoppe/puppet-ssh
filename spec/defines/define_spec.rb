require 'spec_helper'

describe 'ssh::define', type: :define do
  ['Debian'].each do |osfamily|
    let(:facts) do
      {
        osfamily: osfamily
      }
    end
    let(:pre_condition) { 'include ssh' }
    let(:title) { 'sshd_config' }

    context "on #{osfamily}" do
      context 'when source file' do
        let(:params) do
          {
            config_file_path: '/etc/ssh/sshd_config.2nd',
            config_file_source: 'puppet:///modules/ssh/wheezy/etc/ssh/sshd_config'
          }
        end

        it do
          is_expected.to contain_file('define_sshd_config').with(
            'ensure'  => 'present',
            'source'  => 'puppet:///modules/ssh/wheezy/etc/ssh/sshd_config',
            'notify'  => 'Service[ssh]',
            'require' => 'Package[openssh-server]'
          )
        end
      end

      context 'when content string' do
        let(:params) do
          {
            config_file_path: '/etc/ssh/sshd_config.3rd',
            config_file_string: '# THIS FILE IS MANAGED BY PUPPET'
          }
        end

        it do
          is_expected.to contain_file('define_sshd_config').with(
            'ensure'  => 'present',
            'content' => %r{THIS FILE IS MANAGED BY PUPPET},
            'notify'  => 'Service[ssh]',
            'require' => 'Package[openssh-server]'
          )
        end
      end

      context 'when content template' do
        let(:params) do
          {
            config_file_path: '/etc/ssh/sshd_config.4th',
            config_file_template: 'ssh/wheezy/etc/ssh/sshd_config.erb'
          }
        end

        it do
          is_expected.to contain_file('define_sshd_config').with(
            'ensure'  => 'present',
            'content' => %r{THIS FILE IS MANAGED BY PUPPET},
            'notify'  => 'Service[ssh]',
            'require' => 'Package[openssh-server]'
          )
        end
      end

      context 'when content template (custom)' do
        let(:params) do
          {
            config_file_path: '/etc/ssh/sshd_config.5th',
            config_file_template: 'ssh/wheezy/etc/ssh/sshd_config.erb',
            config_file_options_hash: {
              'key' => 'value'
            }
          }
        end

        it do
          is_expected.to contain_file('define_sshd_config').with(
            'ensure'  => 'present',
            'content' => %r{THIS FILE IS MANAGED BY PUPPET},
            'notify'  => 'Service[ssh]',
            'require' => 'Package[openssh-server]'
          )
        end
      end
    end
  end
end
