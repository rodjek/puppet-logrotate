#
# This class implements the prerequisites for using
# rotate_every => 'hour'
# as a parameter for the logrotate::rule define.
#
# This class is not intended to be used directly.
# The exception being, if you need to remove it,
# use it like:
# class {'logrotate::hourly': ensure => 'absent' }
#
class logrotate::hourly ($ensure = 'present') {
  include logrotate::params

  case $ensure {
    'present': {
      $dir_ensure  = 'directory'
    }
    default: {
      $dir_ensure  = $ensure
    }
  }

  file {'logrotate_hourly dir':
    ensure => $dir_ensure,
    path   => $logrotate::params::hourly_path,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  cron {'logrotate_hourly':
    ensure  => $ensure,
    command => "/usr/sbin/logrotate ${logrotate::params::hourly_path}",
    user    => 'root',
    hour    => '*',
    minute  => $::randminute,
    require => File['logrotate_hourly dir'],
  }
}
