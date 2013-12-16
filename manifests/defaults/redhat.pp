# Internal: Manage the default redhat logrotate rules.
#
# Examples
#
#   include logrotate::defaults::redhat
class logrotate::defaults::redhat {
  Logrotate::Rule {
    missingok    => true,
    rotate_every => 'month',
    create       => true,
    create_owner => 'root',
    create_group => 'utmp',
    rotate       => 1,
  }
}
