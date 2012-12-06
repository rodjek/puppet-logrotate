# Internal: Manage the default redhat logrotate rules.
#
# Examples
#
#   include logrotate::defaults::redhat
class logrotate::defaults::redhat {
  Logrotate::Rule {
    rotate_every => 'month',
    create       => true,
    create_owner => 'root',
    create_group => 'utmp',
    rotate       => 1,
  }

  logrotate::rule {
    'wtmp':
      path        => '/var/log/wtmp',
      create_mode => '0664',
      minsize     => '1M';
    'btmp':
      path        => '/var/log/btmp',
      create_mode => '0660',
      missingok   => true;
  }
}
