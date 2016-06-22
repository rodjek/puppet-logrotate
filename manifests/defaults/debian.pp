# Internal: Manage the default debian logrotate rules.
#
# Examples
#
#   include logrotate::defaults::debian
class logrotate::defaults::debian {

  logrotate::rule {
    'wtmp':
      path        => '/var/log/wtmp',
      missingok   => true,
      create      => true,
      create_mode => '0664 root utmp',
      rotate      => '1',
  }
  logrotate::rule {
    'btmp':
      path        => '/var/log/btmp',
      missingok   => true,
      create      => true,
      create_mode => '0664 root utmp',
      rotate      => '1',
  }
}
