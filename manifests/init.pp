class logrotate(
    $package_name       = $::logrotate::params::package_name,
    $package_ensure     = $::logrotate::params::package_ensure,
    $config_file        = $::logrotate::params::logrotate_config_file,
    $config_dir         = $::logrotate::params::logrotate_config_dir,
    $daily_cron_script  = $::logrotate::params::logrotate_daily_cron_script,
    $hourly_cron_script = $::logrotate::params::logrotate_hourly_cron_script,
    $bin_path           = $::logrotate::params::logrotate_bin_path,
    $has_cron_d_feature = $::logrotate::params::has_cron_d_feature
) inherits ::logrotate::params {

    class { '::logrotate::install': } ->
    class { '::logrotate::config': } ->
    class { '::logrotate::defaults': }
}
