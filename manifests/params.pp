# == Class: ssh::params
#
class ssh::params {
  $package_name = $::osfamily ? {
    default => 'openssh-server',
  }

  $package_list = $::osfamily ? {
    default => undef,
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc/ssh',
  }

  $config_file_path = $::osfamily ? {
    default => '/etc/ssh/sshd_config',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'root',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_notify = $::osfamily ? {
    default => 'Service[ssh]',
  }

  $config_file_require = $::osfamily ? {
    default => 'Package[openssh-server]',
  }

  $service_name = $::osfamily ? {
    default => 'ssh',
  }

  case $::osfamily {
    'Debian': {
    }
    default: {
      fail("${::operatingsystem} not supported.")
    }
  }
}
