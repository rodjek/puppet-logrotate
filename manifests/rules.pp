# Class: logrotate::rules
#
# This class loads user given logrotate rules
#
# PRIVATE CLASS: do not call directly
#
# See the primary logrotate module documentation for usage and examples.
#
class logrotate::rules(

  $rules      = $::logrotate::rules,
  $hieramerge = $::logrotate::hieramerge

) {

  # NOTE: hiera_hash does not work as expected in a parameterized class
  #   definition; so we call it here.
  #
  # http://docs.puppetlabs.com/hiera/1/puppet.html#limitations
  # https://tickets.puppetlabs.com/browse/HI-118
  #
  if $hieramerge {
    $x_rules = hiera_hash('logrotate::rules', $rules)

  # Fall back to user given class parameter / priority based hiera lookup
  } else {
    $x_rules = $rules
  }

  if $x_rules {
    create_resources('logrotate::rule', $x_rules)
  }

}

