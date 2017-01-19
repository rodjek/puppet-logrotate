# Internal: Manage the default debian logrotate rules.
#
# Examples
#
#   include logrotate::defaults::debian
class logrotate::defaults::debian {
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
      create_mode => '0664';
    'btmp':
      path        => '/var/log/btmp',
      create_mode => '0600';
  }

  case $::lsbdistrelease {
    '12.04': {
      $rsyslog_command = 'service rsyslog reload'
    }
    '14.04': {
      $rsyslog_command = 'service rsyslog restart'
    }
    '16.04': {
      $rsyslog_command = 'systemctl restart rsyslog'
    }
    default: {
      $rsyslog_command = 'service rsyslog restart'
    }
  }

  file { '/etc/logrotate.d/rsyslog':
    ensure  => file,
    mode    => '0644',
    content => template('logrotate/etc/logrotate.d/rsyslog'),
  }
}
