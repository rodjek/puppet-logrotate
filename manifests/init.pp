#
class logrotate (
  $ensure            = 'latest',
  $hieramerge        = false,
  $manage_cron_daily = true,
  $package           = 'logrotate',
  $rules             = {}
) {

  validate_string($ensure)
  validate_bool($hieramerge)
  validate_bool($manage_cron_daily)
  validate_string($package)
  validate_hash($rules)

  case $ensure {
    'latest': { $_ensure = 'latest' }
    false,'absent': { $_ensure = 'absent' }
    default: { $_ensure = 'presest' }
  }

  package { $package:
    ensure => $_ensure,
  }

  File {
    owner   => 'root',
    group   => 'root',
    require => Package[$package],
  }

  file {'/etc/logrotate.d':
      ensure => directory,
      mode   => '0755',
  }
  if $manage_cron_daily {
    file {'/etc/cron.daily/logrotate':
        ensure => file,
        mode   => '0555',
        source => 'puppet:///modules/logrotate/etc/cron.daily/logrotate',
    }
  }

  case $::osfamily {
    'Debian': {
      include logrotate::defaults::debian
    }
    'RedHat': {
      include logrotate::defaults::redhat
    }
    'SuSE': {
      include logrotate::defaults::suse
    }
    default: {
      if !defined( Logrotate::Conf['/etc/logrotate.conf'] ) {
        logrotate::conf {'/etc/logrotate.conf': }
      }
    }
  }

  if $hieramerge {
    $_rules = hiera_hash('logrotate::rules', $rules)
  } else {
    $_rules = $rules
  }
  
  create_resources('logrotate::rule', $_rules)

}
