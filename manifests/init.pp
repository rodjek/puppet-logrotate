class logrotate (
  $rules = {},
) {
  validate_hash($rules)
  create_resources('logrotate::rule', $rules)
}
