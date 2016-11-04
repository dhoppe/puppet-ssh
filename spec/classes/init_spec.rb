require 'spec_helper'

describe 'ssh', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_anchor('ssh::begin') }
      it { is_expected.to contain_class('ssh::params') }
      it { is_expected.to contain_class('ssh::install') }
      it { is_expected.to contain_class('ssh::config') }
      it { is_expected.to contain_class('ssh::service') }
      it { is_expected.to contain_anchor('ssh::end') }

      describe 'ssh::install' do
        context 'defaults' do
          it do
            is_expected.to contain_package('ssh').with(
              'ensure' => 'present'
            )
          end
        end

        context 'when package latest' do
          let(:params) do
            {
              package_ensure: 'latest'
            }
          end

          it do
            is_expected.to contain_package('ssh').with(
              'ensure' => 'latest'
            )
          end
        end

        context 'when package absent' do
          let(:params) do
            {
              package_ensure: 'absent',
              service_ensure: 'stopped',
              service_enable: false
            }
          end

          it do
            is_expected.to contain_package('ssh').with(
              'ensure' => 'absent'
            )
          end
          it do
            is_expected.to contain_file('ssh.conf').with(
              'ensure'  => 'present',
              'notify'  => 'Service[ssh]',
              'require' => 'Package[ssh]'
            )
          end
          it do
            is_expected.to contain_service('ssh').with(
              'ensure' => 'stopped',
              'enable' => false
            )
          end
        end

        context 'when package purged' do
          let(:params) do
            {
              package_ensure: 'purged',
              service_ensure: 'stopped',
              service_enable: false
            }
          end

          it do
            is_expected.to contain_package('ssh').with(
              'ensure' => 'purged'
            )
          end
          it do
            is_expected.to contain_file('ssh.conf').with(
              'ensure'  => 'absent',
              'notify'  => 'Service[ssh]',
              'require' => 'Package[ssh]'
            )
          end
          it do
            is_expected.to contain_service('ssh').with(
              'ensure' => 'stopped',
              'enable' => false
            )
          end
        end
      end

      describe 'ssh::config' do
        context 'defaults' do
          it do
            is_expected.to contain_file('ssh.conf').with(
              'ensure'  => 'present',
              'notify'  => 'Service[ssh]',
              'require' => 'Package[ssh]'
            )
          end
        end

        context 'when source dir' do
          let(:params) do
            {
              config_dir_source: 'puppet:///modules/ssh/wheezy/etc/ssh'
            }
          end

          it do
            is_expected.to contain_file('ssh.dir').with(
              'ensure'  => 'directory',
              'force'   => false,
              'purge'   => false,
              'recurse' => true,
              'source'  => 'puppet:///modules/ssh/wheezy/etc/ssh',
              'notify'  => 'Service[ssh]',
              'require' => 'Package[ssh]'
            )
          end
        end

        context 'when source dir purged' do
          let(:params) do
            {
              config_dir_purge: true,
              config_dir_source: 'puppet:///modules/ssh/wheezy/etc/ssh'
            }
          end

          it do
            is_expected.to contain_file('ssh.dir').with(
              'ensure'  => 'directory',
              'force'   => true,
              'purge'   => true,
              'recurse' => true,
              'source'  => 'puppet:///modules/ssh/wheezy/etc/ssh',
              'notify'  => 'Service[ssh]',
              'require' => 'Package[ssh]'
            )
          end
        end

        context 'when source file' do
          let(:params) do
            {
              config_file_source: 'puppet:///modules/ssh/wheezy/etc/ssh/sshd_config'
            }
          end

          it do
            is_expected.to contain_file('ssh.conf').with(
              'ensure'  => 'present',
              'source'  => 'puppet:///modules/ssh/wheezy/etc/ssh/sshd_config',
              'notify'  => 'Service[ssh]',
              'require' => 'Package[ssh]'
            )
          end
        end

        context 'when content string' do
          let(:params) do
            {
              config_file_string: '# THIS FILE IS MANAGED BY PUPPET'
            }
          end

          it do
            is_expected.to contain_file('ssh.conf').with(
              'ensure'  => 'present',
              'content' => %r{THIS FILE IS MANAGED BY PUPPET},
              'notify'  => 'Service[ssh]',
              'require' => 'Package[ssh]'
            )
          end
        end

        context 'when content template' do
          let(:params) do
            {
              config_file_template: 'ssh/wheezy/etc/ssh/sshd_config.erb'
            }
          end

          it do
            is_expected.to contain_file('ssh.conf').with(
              'ensure'  => 'present',
              'content' => %r{THIS FILE IS MANAGED BY PUPPET},
              'notify'  => 'Service[ssh]',
              'require' => 'Package[ssh]'
            )
          end
        end

        context 'when content template (custom)' do
          let(:params) do
            {
              config_file_template: 'ssh/wheezy/etc/ssh/sshd_config.erb',
              config_file_options_hash: {
                'key' => 'value'
              }
            }
          end

          it do
            is_expected.to contain_file('ssh.conf').with(
              'ensure'  => 'present',
              'content' => %r{THIS FILE IS MANAGED BY PUPPET},
              'notify'  => 'Service[ssh]',
              'require' => 'Package[ssh]'
            )
          end
        end
      end

      describe 'ssh::service' do
        context 'defaults' do
          it do
            is_expected.to contain_service('ssh').with(
              'ensure' => 'running',
              'enable' => true
            )
          end
        end

        context 'when service stopped' do
          let(:params) do
            {
              service_ensure: 'stopped'
            }
          end

          it do
            is_expected.to contain_service('ssh').with(
              'ensure' => 'stopped',
              'enable' => true
            )
          end
        end
      end
    end
  end
end
