#
# Class: logrotate
#
# Install logrotate and configure it to read from /etc/logrotate.d
#
# Examples
#
#   include logrotate
#
class logrotate(

  $packages   = 'logrotate',
  $rules      = undef,
  $hieramerge = false

) {

  package { $packages:
    ensure => latest,
  }

  File {
    owner   => 'root',
    group   => 'root',
    require => Package[$packages],
  }

  file {
    '/etc/logrotate.conf':
      ensure  => file,
      mode    => '0444',
      source  => 'puppet:///modules/logrotate/etc/logrotate.conf';
    '/etc/logrotate.d':
      ensure  => directory,
      mode    => '0755';
    '/etc/cron.daily/logrotate':
      ensure  => file,
      mode    => '0555',
      source  => 'puppet:///modules/logrotate/etc/cron.daily/logrotate';
  }

  # default rules
  class { "::logrotate::defaults::${::osfamily}":
    require => Package[$packages];
  }

  # user specified rules
  class { '::logrotate::rules':
    requires => Package[$packages];
  }

}

