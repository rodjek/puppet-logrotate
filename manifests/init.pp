#
class logrotate(
  $rules = {},
  $use_hiera = true
)
{
  if ( $use_hiera == true ) {
    $_rules = hiera_hash('logrotate::rules', {})
  }
  else {
    $_rules = $rules
  }

  create_resources('::logrotate::rule', $_rules)
}
