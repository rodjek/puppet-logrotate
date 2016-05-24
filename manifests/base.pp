# Internal: Install logrotate and configure it to read from /etc/logrotate.d
#
# Examples
#
#   include logrotate::base
class logrotate::base (
  $compress      = true,
  $compresscmd   = undef,
  $compressext   = undef,
  $dateext       = false,
  $package_state = 'present',
  $rotate        = 4
){
  package { 'logrotate':
    ensure => $package_state,
  }

  File {
    owner   => 'root',
    group   => 'root',
    require => Package['logrotate'],
  }

  file {
    '/etc/logrotate.conf':
      ensure  => file,
      mode    => '0444',
      content => template('logrotate/etc/logrotate.conf.erb'),;
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
