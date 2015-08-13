require 'spec_helper'

describe 'ssh', :type => :class do
  ['Debian'].each do |osfamily|
    let(:facts) {{
      :osfamily => osfamily,
    }}

#    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_anchor('ssh::begin') }
    it { is_expected.to contain_class('ssh::params') }
    it { is_expected.to contain_class('ssh::install') }
    it { is_expected.to contain_class('ssh::config') }
    it { is_expected.to contain_class('ssh::service') }
    it { is_expected.to contain_anchor('ssh::end') }

    context "on #{osfamily}" do
      describe 'ssh::install' do
        context 'defaults' do
          it do
            is_expected.to contain_package('ssh').with({
              'ensure' => 'present',
            })
          end
        end

        context 'when package latest' do
          let(:params) {{
            :package_ensure => 'latest',
          }}

          it do
            is_expected.to contain_package('ssh').with({
              'ensure' => 'latest',
            })
          end
        end

        context 'when package absent' do
          let(:params) {{
            :package_ensure => 'absent',
            :service_ensure => 'stopped',
            :service_enable => false,
          }}

          it do
            is_expected.to contain_package('ssh').with({
              'ensure' => 'absent',
            })
          end
          it do
            is_expected.to contain_file('ssh.conf').with({
              'ensure'  => 'present',
              'notify'  => 'Service[ssh]',
              'require' => 'Package[openssh-server]',
            })
          end
          it do
            is_expected.to contain_service('ssh').with({
              'ensure' => 'stopped',
              'enable' => false,
            })
          end
        end

        context 'when package purged' do
          let(:params) {{
            :package_ensure => 'purged',
            :service_ensure => 'stopped',
            :service_enable => false,
          }}

          it do
            is_expected.to contain_package('ssh').with({
              'ensure' => 'purged',
            })
          end
          it do
            is_expected.to contain_file('ssh.conf').with({
              'ensure'  => 'absent',
              'notify'  => 'Service[ssh]',
              'require' => 'Package[openssh-server]',
            })
          end
          it do
            is_expected.to contain_service('ssh').with({
              'ensure' => 'stopped',
              'enable' => false,
            })
          end
        end
      end

      describe 'ssh::config' do
        context 'defaults' do
          it do
            is_expected.to contain_file('ssh.conf').with({
              'ensure'  => 'present',
              'notify'  => 'Service[ssh]',
              'require' => 'Package[openssh-server]',
            })
          end
        end

        context 'when source dir' do
          let(:params) {{
            :config_dir_source => 'puppet:///modules/ssh/wheezy/etc/ssh',
          }}

          it do
            is_expected.to contain_file('ssh.dir').with({
              'ensure'  => 'directory',
              'force'   => false,
              'purge'   => false,
              'recurse' => true,
              'source'  => 'puppet:///modules/ssh/wheezy/etc/ssh',
              'notify'  => 'Service[ssh]',
              'require' => 'Package[openssh-server]',
            })
          end
        end

        context 'when source dir purged' do
          let(:params) {{
            :config_dir_purge  => true,
            :config_dir_source => 'puppet:///modules/ssh/wheezy/etc/ssh',
          }}

          it do
            is_expected.to contain_file('ssh.dir').with({
              'ensure'  => 'directory',
              'force'   => true,
              'purge'   => true,
              'recurse' => true,
              'source'  => 'puppet:///modules/ssh/wheezy/etc/ssh',
              'notify'  => 'Service[ssh]',
              'require' => 'Package[openssh-server]',
            })
          end
        end

        context 'when source file' do
          let(:params) {{
            :config_file_source => 'puppet:///modules/ssh/wheezy/etc/ssh/sshd_config',
          }}

          it do
            is_expected.to contain_file('ssh.conf').with({
              'ensure'  => 'present',
              'source'  => 'puppet:///modules/ssh/wheezy/etc/ssh/sshd_config',
              'notify'  => 'Service[ssh]',
              'require' => 'Package[openssh-server]',
            })
          end
        end

        context 'when content string' do
          let(:params) {{
            :config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
          }}

          it do
            is_expected.to contain_file('ssh.conf').with({
              'ensure'  => 'present',
              'content' => /THIS FILE IS MANAGED BY PUPPET/,
              'notify'  => 'Service[ssh]',
              'require' => 'Package[openssh-server]',
            })
          end
        end

        context 'when content template' do
          let(:params) {{
            :config_file_template => 'ssh/wheezy/etc/ssh/sshd_config.erb',
          }}

          it do
            is_expected.to contain_file('ssh.conf').with({
              'ensure'  => 'present',
              'content' => /THIS FILE IS MANAGED BY PUPPET/,
              'notify'  => 'Service[ssh]',
              'require' => 'Package[openssh-server]',
            })
          end
        end

        context 'when content template (custom)' do
          let(:params) {{
            :config_file_template     => 'ssh/wheezy/etc/ssh/sshd_config.erb',
            :config_file_options_hash => {
              'key' => 'value',
            },
          }}

          it do
            is_expected.to contain_file('ssh.conf').with({
              'ensure'  => 'present',
              'content' => /THIS FILE IS MANAGED BY PUPPET/,
              'notify'  => 'Service[ssh]',
              'require' => 'Package[openssh-server]',
            })
          end
        end
      end

      describe 'ssh::service' do
        context 'defaults' do
          it do
            is_expected.to contain_service('ssh').with({
              'ensure' => 'running',
              'enable' => true,
            })
          end
        end

        context 'when service stopped' do
          let(:params) {{
            :service_ensure => 'stopped',
          }}

          it do
            is_expected.to contain_service('ssh').with({
              'ensure' => 'stopped',
              'enable' => true,
            })
          end
        end
      end
    end
  end
end
