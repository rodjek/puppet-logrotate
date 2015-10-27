# Internal: Manage the default suse logrotate rules.
#
# Examples
#
#   include logrotate::defaults::suse
class logrotate::defaults::suse {
  Logrotate::Rule {
    missingok    => true,
    #create       => true,
    #create_owner => 'root',
    #create_group => 'root',
    #create_mode  => '0644',
  }

  logrotate::rule {
    'wtmp':
      path         => '/var/log/wtmp',
      compress     => true,
      dateext      => true,
      maxage       => 365,
      rotate       => 4,
      size         => '4096k',
      ifempty      => false,
      copytruncate => true,
  }
}
