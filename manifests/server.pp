class ssh::server($ensure = 'present',
  $enabled = true,
  $svcensure = 'running',
  $permitroot = 'No',
  $aliveinterval = '60',
  $alivecount = '3',
  $privilegeseparation = 'Yes',
  $maxauth = '2',
  $passwordauth = 'No',
  $usepam = 'No',
  $kerberosauth = 'No',
  $allowusers = '',
  $sshloglevel = 'INFO'
) {
  include ssh::params
  include stdlib

  anchor { 'sshd': }

  if ($ssh::params::serverpkg != undef) {
    package { 'ssh-server':
      ensure => $ensure,
      name   => $ssh::params::serverpkg,
      before => Anchor['sshd'],
    }
  }

  # Validate Parameters
  if ($permitroot !~ /(?i:yes|no|without-password|forced-commands-only)/) {
    fail('permitroot must be one of yes, no, without-password or forced-commands-only')
  }

  if  ($aliveinterval !~ /^\d+$/ or $aliveinterval =~ /^0+$/ ) {
    fail('aliveinterval must be a positive number')
  }

  if  ($alivecount !~ /^\d+$/ or $alivecount =~ /^0+$/ ) {
    fail('alivecount must be a positive number')
  }

  if  ($maxauth !~ /^\d+$/ or $maxauth =~ /^0+$/ ) {
    fail('maxauth must be a positive number')
  }

  if ($privilegeseparation !~ /(?i:yes|no)/) {
    fail('privilegeseparation must be yes or no')
  }

  if ($passwordauth !~ /(?i:yes|no)/) {
    fail('passwordauth must be yes or no')
  }

  if ($usepam !~ /(?i:yes|no)/) {
    fail('usepam must be yes or no')
  }

  if ($kerberosauth !~ /(?i:yes|no)/) {
    fail('kerberosauth must be yes or no')
  }

  validate_re($sshloglevel, [ '^QUIET$', '^FATAL$', '^ERROR$', '^INFO$', '^VERBOSE$', '^DEBUG[1-3]*$'])

  service { 'ssh':
    ensure => $svcensure,
    name   => $ssh::params::service,
    enable => $enabled,
  }

  # All of our sshd_config options that do not allow redefinition
  sshd_config { 'IgnoreRhosts':
    value   => 'yes',
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'HostbasedAuthentication':
    value   => 'no',
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'PermitEmptyPasswords':
    value   => 'no',
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'LogLevel':
    value   => $sshloglevel,
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'StrictModes':
    value   => 'yes',
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'TCPKeepAlive':
    value   => 'no',
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'GSSAPIAuthentication':
    value   => 'no',
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'RhostsAuthentication':
    value   => 'no',
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'PubkeyAuthentication':
    value   => 'yes',
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'Protocol':
    value   => '2',
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'Port':
    value   => '22',
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'RhostsRSAAuthentication':
    value   => 'no',
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  # Params that allow changes
  sshd_config { 'PermitRootLogin':
    value   => downcase($permitroot),
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'ClientAliveInterval':
    value   => $aliveinterval,
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'ClientAliveCountMax':
    value   => $alivecount,
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'UsePrivilegeSeparation':
    value   => downcase($privilegeseparation),
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'MaxAuthTries':
    value   => $maxauth,
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'PasswordAuthentication':
    value   => downcase($passwordauth),
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'UsePAM':
    value   => downcase($usepam),
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  sshd_config { 'KerberosAuthentication':
    value   => downcase($kerberosauth),
    notify  => Service['ssh'],
    require => Anchor['sshd'],
  }

  # Handle AllowUsers
  if ($allowusers != '') {
    sshd_config { 'AllowUsers':
      value   => $allowusers,
      notify  => Service['ssh'],
      require => Anchor['sshd'],
    }
  }

  if ($ssh::params::serverpkg != undef) {
    Package['ssh-server'] -> Service['ssh']
  }

}
