# == Class: logrotate
#
class logrotate {

  package { 'logrotate':
    ensure => latest,
  }

  File {
    owner   => 'root',
    group   => 'root',
    require => Package['logrotate'],
  }

  file { '/etc/logrotate.conf':
      ensure => file,
      mode   => '0444',
      source => 'puppet:///modules/logrotate/logrotate.conf',
  }

  file { '/etc/logrotate.d':
      ensure => directory,
      mode   => '0755',
  }

  file { '/etc/cron.daily/logrotate':
      ensure => file,
      mode   => '0555',
      source => 'puppet:///modules/logrotate/cron.daily/logrotate',
  }

  case $::osfamily {
    'Debian': {
      include ::logrotate::defaults::debian
    }
    'RedHat': {
      include ::logrotate::defaults::redhat
    }
    'SuSE': {
      include ::logrotate::defaults::suse
    }
    default: { }
  }
}
