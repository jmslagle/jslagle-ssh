class ssh::client($ensure = 'present') {
  include ssh::params

  if ($ssh::params::clientpkg != undef) {
    package { $ssh::params::clientpkg:
      ensure => $ensure,
      name   =>  'ssh',
    }
  }

}
