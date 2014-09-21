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
  case $::osfamily {
    'Debian': {
      class { '::logrotate::defaults::debian':
        require => Package[$packages];
      }
    }
    'RedHat': {
      class { '::logrotate::defaults::redhat':
        require => Package[$packages];
      }
    }
    'SuSE': {
      class { '::logrotate::defaults::suse':
        require => Package[$packages];
      }
    }
    default: { }
  }

  # user specified rules
  class { '::logrotate::rules':
    require => Package[$packages];
  }

}

