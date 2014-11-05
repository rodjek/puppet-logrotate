# Internal: Configure a host for hourly logrotate jobs.
#
# ensure - The desired state of hourly logrotate support.  Valid values are
#          'absent' and 'present' (default: 'present').
#
# Examples
#
#   # Set up hourly logrotate jobs
#   include logrotate::hourly
#
#   # Remove hourly logrotate job support
#   class { 'logrotate::hourly':
#     ensure => absent,
#   }
class logrotate::hourly($ensure='present') {

  include ::logrotate

  case $ensure {
    'absent': {
      $dir_ensure = $ensure
    }
    'present': {
      $dir_ensure = 'directory'
    }
    default: {
      fail("Class[Logrotate::Hourly]: Invalid ensure value '${ensure}'")
    }
  }

  File {
    owner   => 'root',
    group   => '0'
  }

  $hourly_config_dir = "${::logrotate::config_dir}/hourly"

  file { $hourly_config_dir:
    ensure  => $dir_ensure,
    mode    => '0755' 
  }

  file { $::logrotate::hourly_cron_script:
    ensure  => $ensure,
    mode    => '0555',
    content => template('logrotate/etc/cron.hourly/logrotate.erb'),
    require => [
      File[$hourly_config_dir],
      Package[$::logrotate::package_name]
    ]
  }

  # For O.S like AIX that does not have /etc/cron.{daily,hourly,...}
  # feature, just create a standard cron task
  if $::logrotate::has_cron_d_feature == false {
    if ! defined(Cron['logrotate-hourly-task']) {
      cron { 'logrotate-hourly-task':
        command     => $::logrotate::hourly_cron_script,
        minute      => ['17'],
        hour        => absent,
        monthday    => absent,
        weekday     => absent,
        user        => 'root',
        ensure      => $ensure
      }
    }
  }
}
