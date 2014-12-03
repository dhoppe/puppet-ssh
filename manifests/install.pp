# == Class: ssh::install
#
class ssh::install {
  if $::ssh::package_name {
    package { 'ssh':
      ensure => $::ssh::package_ensure,
      name   => $::ssh::package_name,
    }
  }

  if $::ssh::package_list {
    ensure_resource('package', $::ssh::package_list, { 'ensure' => $::ssh::package_ensure })
  }
}
