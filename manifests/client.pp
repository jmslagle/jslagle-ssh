class ssh::client(
  $ensure = 'present',
  $protocol = '2',
  $pubkeyauthentication = 'yes'
) {
  include ssh::params

  validate_re($pubkeyauthentication, ['^yes$', '^no$'])
  validate_re($protocol, ['^1$', '^2$', '^1,2$', '^2,1$'])

  if ($ssh::params::clientpkg != undef) {
    package { 'ssh':
      ensure => $ensure,
      name   => $ssh::params::clientpkg,
    }
  }

  ssh_config { 'PubkeyAuthentication':
    value      => downcase($pubkeyauthentication),
  }

  ssh_config { 'Protocol':
    value      => $protocol,
  }

}
