# Class: logrotate::rules
#
# This class enables support for hiera based logrotate rules.
# Hiera functionality is auto enabled during the initial logrotate module load.
#
# See the primary logrotate module documentation for usage and examples.
#
class logrotate::rules {

  # NOTE: hiera_hash does not work as expected in a parameterized class
  #   definition; so we call it here.
  #
  # http://docs.puppetlabs.com/hiera/1/puppet.html#limitations
  # https://tickets.puppetlabs.com/browse/HI-118
  #
  $rules = hiera_hash('logrotate::rules', undef)

  if $rules {
    create_resources('::logrotate::rule', $rules)
  }

}

