# == Class: ssh::config
#
class ssh::config {
  if $::ssh::config_dir_source {
    file { 'ssh.dir':
      ensure  => $::ssh::config_dir_ensure,
      path    => $::ssh::config_dir_path,
      force   => $::ssh::config_dir_purge,
      purge   => $::ssh::config_dir_purge,
      recurse => $::ssh::config_dir_recurse,
      source  => $::ssh::config_dir_source,
      notify  => $::ssh::config_file_notify,
      require => $::ssh::config_file_require,
    }
  }

  if $::ssh::config_file_path {
    file { 'ssh.conf':
      ensure  => $::ssh::config_file_ensure,
      path    => $::ssh::config_file_path,
      owner   => $::ssh::config_file_owner,
      group   => $::ssh::config_file_group,
      mode    => $::ssh::config_file_mode,
      source  => $::ssh::config_file_source,
      content => $::ssh::config_file_content,
      notify  => $::ssh::config_file_notify,
      require => $::ssh::config_file_require,
    }
  }
}
