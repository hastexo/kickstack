#
class kickstack::glance::registry(
  $db_password      = hiera('glance_db_password'),
  $db_user          = hiera('glance_db_user', 'glance'),
  $db_name          = hiera('glance_db_name', 'glance'),
  $db_host          = hiera('db_host', '127.0.0.1'),
  $db_type          = hiera('db_type', $::kickstack::db_type),
  $service_password = hiera('glance_service_password'),
  $service_user     = hiera('glance_service_user', 'glance'),
  $service_tenant   = hiera('service_tenant', 'services'),
  $auth_host        = hiera('auth_internal_address', '127.0.0.1'),
  $verbose          = hiera('verbose', false),
  $debug            = hiera('debug', false),
  $management_nic   = hiera('management_nic', $::kickstack::management_nic)
) inherits kickstack {

  include kickstack::glance::config

  $sql_connection_string = "${db_type}://${db_user}:${db_password}@${db_host}/${db_name}"

  class { '::glance::registry':
    verbose           => $verbose,
    debug             => $debug,
    auth_host         => $auth_host,
    keystone_tenant   => $service_tenant,
    keystone_user     => $service_user,
    keystone_password => $service_password,
    sql_connection    => $sql_connection_string,
  }

  # Export the registry host name string for the service
  data { 'glance_registry_host':
    value => get_ip_from_nic($management_nic),
  }

}
