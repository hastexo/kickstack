#
class kickstack::horizon(
  $auth_host  = hiera('auth_internal_host', '127.0.0.1'),
  $secret_key = hiera('horizon_secret_key'),
  $verbose    = hiera('verbose', $::kickstack::verbose),
  $debug      = hiera('debug', $::kickstack::debug),
) inherits kickstack {

  include kickstack::memcached

  if $verbose {
    $django_debug = 'False'
    $log_level = 'INFO'
  } elsif $debug {
    $django_debug = 'True'
    $log_level = 'DEBUG'
  } else {
    $django_debug = 'False'
    $log_level = 'WARNING'
  }

  class { '::horizon':
    secret_key            => $secret_key,
    cache_server_ip       => '127.0.0.1',
    cache_server_port     => '11211',
    keystone_host         => $auth_host,
    keystone_default_role => 'Member',
    django_debug          => $django_debug,
    api_result_limit      => 1000,
    log_level             => $log_level,
    can_set_mount_point   => 'True',
    listen_ssl            => false,
    require               => Package['memcached'],
  }

  data { 'horizon_secret_key':
    value => $secret_key,
  }
}

