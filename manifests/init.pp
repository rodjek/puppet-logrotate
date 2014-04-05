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

  $packages = 'logrotate',

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

  # Load the Hiera based logrotate configuration (if enabled and present)
  #
  # NOTE: We must use 'include' here to avoid circular dependencies with
  #     logrotate::rule
  #
  # NOTE: There is no way to detect the existence of hiera. This automatic
  #   functionality is therefore made exclusive to Puppet 3+ (hiera is embedded)
  #   in order to preserve backwards compatibility.
  #
  #   http://projects.puppetlabs.com/issues/12345
  #
  if (versioncmp($::puppetversion, '3') != -1) {
    include ::logrotate::rules
  }

}

