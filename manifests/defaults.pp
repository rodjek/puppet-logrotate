class logrotate::defaults {
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
}
