# ssh

[![Build Status](https://travis-ci.org/dhoppe/puppet-ssh.png?branch=master)](https://travis-ci.org/dhoppe/puppet-ssh)
[![Code Coverage](https://coveralls.io/repos/github/dhoppe/puppet-ssh/badge.svg?branch=master)](https://coveralls.io/github/dhoppe/puppet-ssh)
[![Puppet Forge](https://img.shields.io/puppetforge/v/dhoppe/ssh.svg)](https://forge.puppetlabs.com/dhoppe/ssh)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/dhoppe/ssh.svg)](https://forge.puppetlabs.com/dhoppe/ssh)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/dhoppe/ssh.svg)](https://forge.puppetlabs.com/dhoppe/ssh)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/dhoppe/ssh.svg)](https://forge.puppetlabs.com/dhoppe/ssh)

#### Table of Contents

1. [Overview](#overview)
1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with ssh](#setup)
    * [What ssh affects](#what-ssh-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with ssh](#beginning-with-ssh)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

This module installs, configures and manages the SSH service.

## Module Description

This module handles installing, configuring and running SSH across a range of
operating systems and distributions.

## Setup

### What ssh affects

* ssh package.
* ssh configuration file.
* ssh service.

### Setup Requirements

* Puppet >= 3.0
* Facter >= 1.6
* [Stdlib module](https://github.com/puppetlabs/puppetlabs-stdlib)

### Beginning with ssh

Install ssh with the default parameters ***(No configuration files will be changed)***.

```puppet
    class { 'ssh': }
```

Install ssh with the recommended parameters.

```puppet
    class { 'ssh':
      config_file_template => "ssh/${::lsbdistcodename}/etc/ssh/sshd_config.erb",
    }
```

## Usage

Update the ssh package.

```puppet
    class { 'ssh':
      package_ensure => 'latest',
    }
```

Remove the ssh package.

```puppet
    class { 'ssh':
      package_ensure => 'absent',
    }
```

Purge the ssh package ***(All configuration files will be removed)***.

```puppet
    class { 'ssh':
      package_ensure => 'purged',
    }
```

Deploy the configuration files from source directory.

```puppet
    class { 'ssh':
      config_dir_source => "puppet:///modules/ssh/${::lsbdistcodename}/etc/ssh",
    }
```

Deploy the configuration files from source directory ***(Unmanaged configuration
files will be removed)***.

```puppet
    class { 'ssh':
      config_dir_purge  => true,
      config_dir_source => "puppet:///modules/ssh/${::lsbdistcodename}/etc/ssh",
    }
```

Deploy the configuration file from source.

```puppet
    class { 'ssh':
      config_file_source => "puppet:///modules/ssh/${::lsbdistcodename}/etc/ssh/sshd_config",
    }
```

Deploy the configuration file from string.

```puppet
    class { 'ssh':
      config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
    }
```

Deploy the configuration file from template.

```puppet
    class { 'ssh':
      config_file_template => "ssh/${::lsbdistcodename}/etc/ssh/sshd_config.erb",
    }
```

Deploy the configuration file from custom template ***(Additional parameters can
be defined)***.

```puppet
    class { 'ssh':
      config_file_template     => "ssh/${::lsbdistcodename}/etc/ssh/sshd_config.erb",
      config_file_options_hash => {
        'key' => 'value',
      },
    }
```

Deploy additional configuration files from source, string or template.

```puppet
    class { 'ssh':
      config_file_hash => {
        'ssh.2nd.conf' => {
          config_file_path   => '/etc/ssh/ssh.2nd.conf',
          config_file_source => "puppet:///modules/ssh/${::lsbdistcodename}/etc/ssh/ssh.2nd.conf",
        },
        'ssh.3rd.conf' => {
          config_file_path   => '/etc/ssh/ssh.3rd.conf',
          config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
        },
        'ssh.4th.conf' => {
          config_file_path     => '/etc/ssh/ssh.4th.conf',
          config_file_template => "ssh/${::lsbdistcodename}/etc/ssh/ssh.4th.conf.erb",
        },
      },
    }
```

Disable the ssh service.

```puppet
    class { 'ssh':
      service_ensure => 'stopped',
    }
```

## Reference

### Classes

#### Public Classes

* ssh: Main class, includes all other classes.

#### Private Classes

* ssh::install: Handles the packages.
* ssh::config: Handles the configuration file.
* ssh::service: Handles the service.

### Parameters

#### `package_ensure`

Determines if the package should be installed. Valid values are 'present', 'latest',
'absent' and 'purged'. Defaults to 'present'.

#### `package_name`

Determines the name of package to manage. Defaults to 'openssh-server'.

#### `package_list`

Determines if additional packages should be managed. Defaults to 'undef'.

#### `config_dir_ensure`

Determines if the configuration directory should be present. Valid values are
'absent' and 'directory'. Defaults to 'directory'.

#### `config_dir_path`

Determines if the configuration directory should be managed. Defaults to '/etc/ssh'

#### `config_dir_purge`

Determines if unmanaged configuration files should be removed. Valid values are
'true' and 'false'. Defaults to 'false'.

#### `config_dir_recurse`

Determines if the configuration directory should be recursively managed. Valid
values are 'true' and 'false'. Defaults to 'true'.

#### `config_dir_source`

Determines the source of a configuration directory. Defaults to 'undef'.

#### `config_file_ensure`

Determines if the configuration file should be present. Valid values are 'absent'
and 'present'. Defaults to 'present'.

#### `config_file_path`

Determines if the configuration file should be managed. Defaults to '/etc/ssh/sshd_config'

#### `config_file_owner`

Determines which user should own the configuration file. Defaults to 'root'.

#### `config_file_group`

Determines which group should own the configuration file. Defaults to 'root'.

#### `config_file_mode`

Determines the desired permissions mode of the configuration file. Defaults to '0644'.

#### `config_file_source`

Determines the source of a configuration file. Defaults to 'undef'.

#### `config_file_string`

Determines the content of a configuration file. Defaults to 'undef'.

#### `config_file_template`

Determines the content of a configuration file. Defaults to 'undef'.

#### `config_file_notify`

Determines if the service should be restarted after configuration changes.
Defaults to 'Service[ssh]'.

#### `config_file_require`

Determines which package a configuration file depends on. Defaults to 'Package[openssh-server]'.

#### `config_file_hash`

Determines which configuration files should be managed via `ssh::define`.
Defaults to '{}'.

#### `config_file_options_hash`

Determines which parameters should be passed to an ERB template. Defaults to '{}'.

#### `service_ensure`

Determines if the service should be running or not. Valid values are 'running'
and 'stopped'. Defaults to 'running'.

#### `service_name`

Determines the name of service to manage. Defaults to 'ssh'.

#### `service_enable`

Determines if the service should be enabled at boot. Valid values are 'true'
and 'false'. Defaults to 'true'.

#### `allow_groups`

Determines which groups are allowed to login. Defaults to '[]'.

#### `allow_users`

Determines which users are allowed to login. Defaults to '[]'.

#### `deny_groups`

Determines which groups are not allowed to login. Defaults to '[]'.

#### `deny_users`

Determines which users are not allowed to login. Defaults to '[]'.

#### `password_authentication`

Determines if password authentication is allowed. Valid values are 'yes' and 'no'.
Defaults to 'yes'.

#### `permit_root_login`

Determines if user root is allowed to login. Valid values are 'yes' and 'no'.
Defaults to 'no'.

#### `pubkey_authentication`

Determines if public key authentication is allowed. Valid values are 'yes' and
'no'. Defaults to 'yes'.

#### `use_dns`

Determines if the remote hostname should be resolved. Valid values are 'yes' and
'no'. Defaults to 'yes'.

#### `use_pam`

Determines if the Pluggable Authentication Module should be enabled. Valid values
are 'yes' and 'no'. Defaults to 'yes'.

## Limitations

This module has been tested on:

* Debian 6/7/8
* Ubuntu 12.04/14.04/16.04

## Development

### Bug Report

If you find a bug, have trouble following the documentation or have a question
about this module - please create an issue.

### Pull Request

If you are able to patch the bug or add the feature yourself - please make a
pull request.

### Contributors

The list of contributors can be found at: [https://github.com/dhoppe/puppet-ssh/graphs/contributors](https://github.com/dhoppe/puppet-ssh/graphs/contributors)
