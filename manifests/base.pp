# Internal: Install logrotate and configure it to read from /etc/logrotate.d
#
# see logrotate::rule for description of options.
#
# Examples
#
#   include logrotate::base
class logrotate::base (
    $ensure = 'latest'
) {

  case $ensure {
    'latest': { $_ensure = 'latest' }
    false,'absent': { $_ensure = 'absent' }
    default: { $_ensure = 'presest' }
  }

  package { 'logrotate':
    ensure => $_ensure,
  }

  File {
    owner   => 'root',
    group   => 'root',
    require => Package['logrotate'],
  }

  if !defined( Logrotate::Conf['/etc/logrotate.conf'] ) {
    logrotate::conf {'/etc/logrotate.conf': }
  }

  file {
    '/etc/logrotate.d':
      ensure  => directory,
      mode    => '0755';
    '/etc/cron.daily/logrotate':
      ensure  => file,
      mode    => '0555',
      source  => 'puppet:///modules/logrotate/etc/cron.daily/logrotate';
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
    default: { }
  }
}
