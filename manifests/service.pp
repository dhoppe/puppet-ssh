# == Class: ssh::service
#
class ssh::service {
  if $::ssh::service_name {
    service { 'ssh':
      ensure     => $::ssh::_service_ensure,
      name       => $::ssh::service_name,
      enable     => $::ssh::_service_enable,
      hasrestart => true,
    }
  }
}
