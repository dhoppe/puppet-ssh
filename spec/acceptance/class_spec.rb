require 'spec_helper_acceptance'

case fact('osfamily')
when 'Debian'
  package_name     = 'openssh-server'
  config_dir_path  = '/etc/ssh'
  config_file_path = '/etc/ssh/sshd_config'
  service_name     = 'ssh'
end

describe 'ssh', :if => SUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  it 'is_expected.to work with no errors' do
    pp = <<-EOS
      class { 'ssh': }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
  end

  describe 'ssh::install' do
    context 'defaults' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'ssh': }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe package(package_name) do
        it { is_expected.to be_installed }
      end
    end

    context 'when package latest' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'ssh':
            package_ensure => 'latest',
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe package(package_name) do
        it { is_expected.to be_installed }
      end
    end

    context 'when package absent' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'ssh':
            package_ensure => 'absent',
            service_ensure => 'stopped',
            service_enable => false,
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe package(package_name) do
        it { is_expected.not_to be_installed }
      end
      describe file(config_file_path) do
        it { is_expected.to be_file }
      end
      describe service(service_name) do
        it { is_expected.not_to be_running }
        it { is_expected.not_to be_enabled }
      end
    end

    context 'when package purged' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'ssh':
            package_ensure => 'purged',
            service_ensure => 'stopped',
            service_enable => false,
          }
        EOS

        apply_manifest(pp, :expect_failures => true)
      end

      describe package(package_name) do
        it { is_expected.not_to be_installed }
      end
      describe file(config_file_path) do
        it { is_expected.not_to be_file }
      end
      describe service(service_name) do
        it { is_expected.not_to be_running }
        it { is_expected.not_to be_enabled }
      end
    end
  end

  describe 'ssh::config' do
    context 'defaults' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'ssh': }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe file(config_file_path) do
        it { is_expected.to be_file }
      end
    end

    context 'when content template' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'ssh':
            config_file_template => "ssh/#{fact('lsbdistcodename')}/#{config_file_path}.erb",
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe file(config_file_path) do
        it { is_expected.to be_file }
        it { is_expected.to contain 'THIS FILE IS MANAGED BY PUPPET' }
      end
    end
  end

  describe 'ssh::service' do
    context 'defaults' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'ssh': }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe service(service_name) do
        it { is_expected.to be_running }
        it { is_expected.to be_enabled }
      end
    end

    context 'when service stopped' do
      it 'is_expected.to work with no errors' do
        pp = <<-EOS
          class { 'ssh':
            service_ensure => 'stopped',
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end

      describe service(service_name) do
        it { is_expected.not_to be_running }
        it { is_expected.to be_enabled }
      end
    end
  end
end
