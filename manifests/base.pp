# Internal: Install logrotate and configure it to read from /etc/logrotate.d
#
# Examples
#
#   include logrotate::base
class logrotate::base {
  package { 'logrotate':
    ensure => latest,
  }

  File {
    owner   => 'root',
    group   => 'root',
    require => Package['logrotate'],
  }


  case $::osfamily {
    'SuSE': {
      $cfg_mode = '0644'
      $cfg_file = 'puppet:///modules/logrotate/etc/logrotate.conf.SuSE'
      $cron_mode = '0755'
      $cron_file = 'puppet:///modules/logrotate/etc/cron.daily/logrotate.SuSE'
    }
    default: {
      $cfg_mode = '0444'
      $cfg_file = 'puppet:///modules/logrotate/etc/logrotate.conf'
      $cron_mode = '0555'
      $cron_file = 'puppet:///modules/logrotate/etc/cron.daily/logrotate'
    }
  }

  file {
    '/etc/logrotate.conf':
      ensure  => file,
      mode    => $cfg_mode,
      source  => $cfg_file;
    '/etc/logrotate.d':
      ensure  => directory,
      mode    => '0755';
    '/etc/cron.daily/logrotate':
      ensure  => file,
      mode    => $cron_mode,
      source  => $cron_file;
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
