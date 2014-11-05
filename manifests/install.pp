class logrotate::install {

    include ::logrotate

    package { $::logrotate::package_name:
        ensure  => $::logrotate::package_ensure
    }
}
