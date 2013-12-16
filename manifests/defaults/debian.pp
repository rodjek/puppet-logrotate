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
    rotate       => 1,
  }
}
