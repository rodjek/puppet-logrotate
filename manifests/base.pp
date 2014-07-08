# Internal: Install logrotate and configure it to read from /etc/logrotate.d
#
# Examples
#
#   include logrotate::base
class logrotate::base(
  $backup     = false,
  $pkg_ensure = 'latest',
  $pkg_name   = 'logrotate',
  $purge      = false,
){
  validate_bool($purge)
  validate_bool($backup)

  validate_string($pkg_ensure)
  validate_string($pkg_name)

  package { $pkg_name:
    ensure => $pkg_ensure,
    alias  => 'logrotate',
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
      source  => 'puppet:///modules/logrotate/etc/logrotate.conf';
    '/etc/logrotate.d':
      ensure  => directory,
      backup  => $backup,
      mode    => '0755',
      purge   => $purge;
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
