class logrotate::config {

    include ::logrotate

    File {
        owner   => 'root',
        group   => '0'
    }

    file { $::logrotate::config_file:
        ensure  => file,
        mode    => '0444',
        content => template('logrotate/etc/logrotate.conf.erb')
    }

    file { $::logrotate::config_dir:
        ensure  => directory,
        mode    => '0755'
    }

    file { $::logrotate::daily_cron_script:
        ensure  => file,
        mode    => '0555',
        content => template('logrotate/etc/cron.daily/logrotate.erb')
    }

    # For O.S like AIX that does not have /etc/cron.{daily,hourly,...}
    # feature, just create a standard cron task
    if $::logrotate::has_cron_d_feature == false {
        cron { 'logrotate-daily-task':
            command     => $::logrotate::daily_cron_script,
            minute      => ['25'],
            hour        => ['06'],
            monthday    => absent,
            weekday     => absent,
            user        => 'root',
            ensure      => 'present'
        }
    }
}
