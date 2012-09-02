class ssh::server($ensure = 'present',
  $enabled = true,
  $svcensure = 'running',
  $permitroot = 'No',
  $aliveinterval = '60',
  $alivecount = '3',
  $privilegeseperation = 'Yes',
  $maxauth = '2',
  $passwordauth = 'No',
  $usepam = 'No',
  $kerberosauth = 'No',
  $allowusers = ""
) {
  include ssh::params

  if ($ssh::params::serverpkg != undef) {
    package { $ssh::params::serverpkg:
      ensure => $ensure,
      name   =>  'ssh-server',
    }
  }

  # Validate Parameters
  if ($permitroot !~ /(?i:yes|no|without-password|forced-commands-only)/) {
    fail("permitroot must be one of yes, no, without-password or forced-commands-only")
  }

  if  ($aliveinterval !~ /^\d+$/ or $aliveinterval =~ /^0+$/ ) {
    fail("aliveinterval must be a positive number")
  }

  if  ($alivecount !~ /^\d+$/ or $alivecount =~ /^0+$/ ) {
    fail("alivecount must be a positive number")
  }

  if  ($maxauth !~ /^\d+$/ or $maxauth =~ /^0+$/ ) {
    fail("maxauth must be a positive number")
  }

  if ($privilegeseperation !~ /(?i:yes|no)/) {
    fail("privilegeseperation must be yes or no")
  }

  if ($passwordauth !~ /(?i:yes|no)/) {
    fail("passwordauth must be yes or no")
  }

  if ($usepam !~ /(?i:yes|no)/) {
    fail("usepam must be yes or no")
  }

  if ($kerberosauth !~ /(?i:yes|no)/) {
    fail("kerberosauth must be yes or no")
  }
  service { 'ssh':
    ensure  => $svcensure,
    name    => $ssh::params::service,
    enable  => $enabled,
  }

  # All of our sshd_config options that do not allow redefinition
  sshd_config { 'IgnoreRhosts':
    value  => 'No',
    notify => Service['ssh'],
  }

  sshd_config { 'HostbasedAuthentication':
    value => 'No',
    notify => Service['ssh'],
  }

  sshd_config { 'PermitEmptyPasswords':
    value => 'No',
    notify => Service['ssh'],
  }

  sshd_config { 'LogLevel':
    value  => 'INFO',
    notify => Service['ssh'],
  }

  sshd_config { 'StrictModes':
    value  => 'Yes',
    notify => Service['ssh'],
  }

  sshd_config { 'TCPKeepAlive':
    value  => 'No',
    notify => Service['ssh'],
  }

  sshd_config { 'GSSAPIAuthentication':
    value  => 'No',
    notify => Service['ssh'],
  }

  # Params that allow changes
  sshd_config { 'PermitRootLogin':
    value  => $permitroot,
    notify => Service['ssh'],
  }

  sshd_config { 'ClientAliveInterval':
    value  => $aliveinterval,
    notify => Service['ssh'],
  }

  sshd_config { 'ClientAliveCountMax':
    value  => $alivecount,
    notify => Service['ssh'],
  }

  sshd_config { 'UsePrivilegeSeperation':
    value  => $privilegeseperation,
    notify => Service['ssh'],
  }

  sshd_config { 'MaxAuthTries':
    value  => $maxauth,
    notify => Service['ssh'],
  }

  sshd_config { 'PasswordAuthentication':
    value  => $passwordauth,
    notify => Service['ssh'],
  }

  sshd_config { 'UsePAM':
    value  => $usepam,
    notify => Service['ssh'],
  }

  sshd_config { 'KerberosAuthentication':
    value  => $kerberosauth,
    notify => Service['ssh'],
  }

  # Handle AllowUsers
  if ($allowusers != "") {
    sshd_config { 'AllowUsers':
      value => $allowusers,
      notify => Service['ssh'],
    }
  }

  if ($ssh::params::serverpkg != undef) {
    Package['ssh-server'] -> Service['ssh']
  }

}
