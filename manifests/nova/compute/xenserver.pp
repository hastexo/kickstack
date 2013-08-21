#
class kickstack::nova::compute::xenserver(
  $connection_url      = hiera('xenapi_connection_url'),
  $connection_username = hiera('xenapi_connection_username'),
  $connection_password = hiera('xenapi_connection_password'),
) inherits kickstack {

  include kickstack::nova::config

  class { '::nova::compute::xenserver':
    xenapi_connection_url      => $connection_url,
    xenapi_connection_username => $connection_username,
    xenapi_connection_password => $connection_password,
  }
}
