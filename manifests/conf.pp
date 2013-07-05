# Internal: Install and configure logrotate defaults file, usually
#   /etc/logrotate.conf
#
# see logrotate::rule for description of options.
#
# Examples
#
#   logrotate::conf{'/etc/logrotate.conf':}
#
define logrotate::conf (
    $ensure          = 'present',
    $compress        = 'undef',
    $compresscmd     = 'undef',
    $compressext     = 'undef',
    $compressoptions = 'undef',
    $copy            = 'undef',
    $copytruncate    = 'undef',
    $create          = true,
    $create_mode     = 'undef',
    $create_owner    = 'undef',
    $create_group    = 'undef',
    $dateext         = 'undef',
    $dateformat      = 'undef',
    $delaycompress   = 'undef',
    $extension       = 'undef',
    $ifempty         = 'undef',
    $mail            = 'undef',
    $mailfirst       = 'undef',
    $maillast        = 'undef',
    $maxage          = 'undef',
    $minsize         = 'undef',
    $missingok       = 'undef',
    $olddir          = 'undef',
    $postrotate      = 'undef',
    $prerotate       = 'undef',
    $firstaction     = 'undef',
    $lastaction      = 'undef',
    $rotate          = '4',
    $rotate_every    = 'weekly',
    $size            = 'undef',
    $sharedscripts   = 'undef',
    $shred           = 'undef',
    $shredcycles     = 'undef',
    $start           = 'undef',
    $su_user         = 'undef',
    $su_group        = 'undef',
    $uncompresscmd   = 'undef'
) {

#############################################################################
# SANITY CHECK VALUES

  if $name !~ /^[a-zA-Z0-9\._\/-]+$/ {
    fail("Logrotate::Rule[${name}]: namevar must be alphanumeric")
  }

  case $ensure {
    'present','file': {}
    'absent': {}
    default: {
      fail("Logrotate::Rule[${name}]: invalid ensure value")
    }
  }

  case $compress {
    'undef': {}
    true: { $_compress = 'compress' }
    false: { $_compress = 'nocompress' }
    default: {
      fail("Logrotate::Rule[${name}]: compress must be a boolean")
    }
  }

  case $copy {
    'undef': {}
    true: { $_copy = 'copy' }
    false: { $_copy = 'nocopy' }
    default: {
      fail("Logrotate::Rule[${name}]: copy must be a boolean")
    }
  }

  case $copytruncate {
    'undef': {}
    true: { $_copytruncate = 'copytruncate' }
    false: { $_copytruncate = 'nocopytruncate' }
    default: {
      fail("Logrotate::Rule[${name}]: copytruncate must be a boolean")
    }
  }

  case $create {
    'undef': {}
    true: { $_create = 'create' }
    false: { $_create = 'nocreate' }
    default: {
      fail("Logrotate::Rule[${name}]: create must be a boolean")
    }
  }

  case $delaycompress {
    'undef': {}
    true: { $_delaycompress = 'delaycompress' }
    false: { $_delaycompress = 'nodelaycompress' }
    default: {
      fail("Logrotate::Rule[${name}]: delaycompress must be a boolean")
    }
  }

  case $dateext {
    'undef': {}
    true: { $_dateext = 'dateext' }
    false: { $_dateext = 'nodateext' }
    default: {
      fail("Logrotate::Rule[${name}]: dateext must be a boolean")
    }
  }

  case $mail {
    'undef': {}
    false: { $_mail = 'nomail' }
    default: {
      $_mail = "mail ${mail}"
    }
  }

  case $missingok {
    'undef': {}
    true: { $_missingok = 'missingok' }
    false: { $_missingok = 'nomissingok' }
    default: {
      fail("Logrotate::Rule[${name}]: missingok must be a boolean")
    }
  }

  case $olddir {
    'undef': {}
    false: { $_olddir = 'noolddir' }
    default: {
      $_olddir = "olddir ${olddir}"
    }
  }

  case $sharedscripts {
    'undef': {}
    true: { $_sharedscripts = 'sharedscripts' }
    false: { $_sharedscripts = 'nosharedscripts' }
    default: {
      fail("Logrotate::Rule[${name}]: sharedscripts must be a boolean")
    }
  }

  case $shred {
    'undef': {}
    true: { $_shred = 'shred' }
    false: { $_shred = 'noshred' }
    default: {
      fail("Logrotate::Rule[${name}]: shred must be a boolean")
    }
  }

  case $ifempty {
    'undef': {}
    true: { $_ifempty = 'ifempty' }
    false: { $_ifempty = 'notifempty' }
    default: {
      fail("Logrotate::Rule[${name}]: ifempty must be a boolean")
    }
  }

  case $rotate_every {
    'undef': {}
    'day': { $_rotate_every = 'daily' }
    'week': { $_rotate_every = 'weekly' }
    'month': { $_rotate_every = 'monthly' }
    'year': { $_rotate_every = 'yearly' }
    'daily', 'weekly','monthly','yearly': { $_rotate_every = $rotate_every }
    default: {
      fail("Logrotate::Rule[${name}]: invalid rotate_every value")
    }
  }

  case $maxage {
    'undef': {}
    /^\d+$/: {}
    default: {
      fail("Logrotate::Rule[${name}]: maxage must be an integer")
    }
  }

  case $minsize {
    'undef': {}
    /^\d+[kMG]?$/: {}
    default: {
      fail("Logrotate::Rule[${name}]: minsize must match /\\d+[kMG]?/")
    }
  }

  case $rotate {
    'undef': {}
    /^\d+$/: {}
    default: {
      fail("Logrotate::Rule[${name}]: rotate must be an integer")
    }
  }

  case $size {
    'undef': {}
    /^\d+[kMG]?$/: {}
    default: {
      fail("Logrotate::Rule[${name}]: size must match /\\d+[kMG]?/")
    }
  }

  case $shredcycles {
    'undef': {}
    /^\d+$/: {}
    default: {
      fail("Logrotate::Rule[${name}]: shredcycles must be an integer")
    }
  }

  case $start {
    'undef': {}
    /^\d+$/: {}
    default: {
      fail("Logrotate::Rule[${name}]: start must be an integer")
    }
  }

  case $su_user {
    'undef': {}
    /[a-z_][a-z0-9_]{0,30}/: {}
    default: {
      fail("Logrotate::Rule[${name}]: su_user must match /[a-z_][a-z0-9_]{0,30}/")
    }
  }

  case $su_group {
    'undef': {}
    /[a-z_][a-z0-9_]{0,30}/: {}
    default: {
      fail("Logrotate::Rule[${name}]: su_group must match /[a-z_][a-z0-9_]{0,30}/")
    }
  }

  case $mailfirst {
    'undef',false: {}
    true: {
      if $maillast == true {
        fail("Logrotate::Rule[${name}]: Can't set both mailfirst and maillast")
      }

      $_mailfirst = 'mailfirst'
    }
    default: {
      fail("Logrotate::Rule[${name}]: mailfirst must be a boolean")
    }
  }

  case $maillast {
    'undef',false: {}
    true: {
      $_maillast = 'maillast'
    }
    default: {
      fail("Logrotate::Rule[${name}]: maillast must be a boolean")
    }
  }

  if ($su_user != 'undef') and ($su_group == 'undef') {
    $_su_user  = $_su_user
    $_su_group = 'root'
  } elsif ($su_user == 'undef') and ($su_group != 'undef') {
    $_su_user  = 'root'
    $_su_group = $su_group
  } else {
    $_su_user  = $su_user
    $_su_group = $su_group
  }

  if ($create_group != 'undef') and ($create_owner == 'undef') {
    fail("Logrotate::Rule[${name}]: create_group requires create_owner")
  }

  if ($create_owner != 'undef') and ($create_mode == 'undef') {
    fail("Logrotate::Rule[${name}]: create_owner requires create_mode")
  }

  if ($create_mode != 'undef') and ($create != true) {
    fail("Logrotate::Rule[${name}]: create_mode requires create")
  }

#
####################################################################

  include ::logrotate

  file { $name:
      ensure  => $ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      content => template('logrotate/etc/logrotate.conf.erb'),
      require => Package['logrotate'],
  }
}
