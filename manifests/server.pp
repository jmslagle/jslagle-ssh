class ssh::server($ensure = 'present', $enabled = true,
                  $svcensure = 'present') {
  include ssh::params

  if ($ssh::params::serverpkg != undef) {
    package { $ssh::params::serverpkg:
      ensure => $ensure;
      name   =>  'ssh-server',
    }
  }

  service { 'ssh':
    ensure  => $svcensure,
    name    => $ssh::params::service,
    enable  => $enabled,
  }
  if ($ssh::params::serverpkg != undef) {
    Package['ssh-server'] -> Service['ssh']
  }

}
