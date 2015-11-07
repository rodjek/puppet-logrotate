# Internal: Manage the default redhat logrotate rules.
#
# Examples
#
#   include ::logrotate::defaults::redhat
#
class logrotate::defaults::redhat {

  Logrotate::Rule {
    missingok    => true,
    rotate_every => 'month',
    create       => true,
    create_owner => 'root',
    create_group => 'utmp',
    rotate       => '1',
  }

  logrotate::rule {
    'wtmp':
      path        => '/var/log/wtmp',
      create_mode => '0664',
      missingok   => false,
      minsize     => '1M',
  }

  logrotate::rule { 'btmp':
      path        => '/var/log/btmp',
      create_mode => '0600',
      minsize     => '1M',
  }
}
