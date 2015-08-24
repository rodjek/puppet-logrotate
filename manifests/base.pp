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
    'Debian': {
      include logrotate::defaults::debian
      $logrotate_file = 'logrotate'
    }
    'RedHat': {
      include logrotate::defaults::redhat
      $logrotate_file = 'logrotate'
    }
    'SuSE': {
      include logrotate::defaults::suse
      $logrotate_file = 'logrotate.sles'
    }
    default: {
      $logrotate_file = 'logrotate'
    }
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
      source  => "puppet:///modules/logrotate/etc/cron.daily/${logrotate_file}";
  }

}
