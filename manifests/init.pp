#
# Class: logrotate
#
# Manages logrotate by taking multiple rules as a hash.  
# The $rules parameter takes a hash with rules.
#
# Usage:
# include logrotate
#
class logrotate (
  $rules = hiera_hash('logrotate::rules', undef)
) {
  if $rules {
    create_resources(logrotate::rule, $rules)
  }
}