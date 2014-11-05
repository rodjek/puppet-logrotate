class logrotate::params {
    $package_name = 'logrotate'
    $package_ensure = 'latest'
    $logrotate_config_file = '/etc/logrotate.conf'
    $logrotate_config_dir = '/etc/logrotate.d'
    $logrotate_bin_path = '/usr/sbin/logrotate'

    case $::osfamily {
        'AIX': {
            # Note(riton):
            # If someone finds a better place to drop those scripts, be my
            # guest.
            $logrotate_daily_cron_script = '/usr/bin/logrotate.daily'
            $logrotate_hourly_cron_script = '/usr/bin/logrotate.hourly'
            $has_cron_d_feature = false
        }
        default: {
            $logrotate_daily_cron_script = '/etc/cron.daily/logrotate'
            $logrotate_hourly_cron_script = '/etc/cron.hourly/logrotate'
            $has_cron_d_feature = true 
        }
    }
}
