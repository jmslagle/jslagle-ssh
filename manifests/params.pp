class ssh::params {
  case $::osfamily {
    'RedHat': {
      $clientpkg = 'openssh-clients'
      $serverpkg = 'openssh-server'
      $service   = 'sshd'
    }
    'Debian': {
      $clientpkg = 'openssh-client'
      $serverpkg = 'openssh-server'
      $service   = 'ssh'
    }
    'FreeBSD': {
      # No packages - base system
      $service   = 'ssh'
    }
    default: {
      err("OSFamily $::osfamily not supported")
    }
  }
}
