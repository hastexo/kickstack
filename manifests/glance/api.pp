#
class kickstack::glance::api(
  $db_password      = hiera('glance_db_password'),
  $db_user          = hiera('glance_db_user', 'glance'),
  $db_name          = hiera('glance_db_name', 'glance'),
  $db_host          = hiera('db_host', '127.0.0.1'),
  $db_type          = hiera('db_type', $::kickstack::db_type),
  $service_password = hiera('glance_service_password'),
  $service_user     = hiera('glance_service_user', 'glance'),
  $service_tenant   = hiera('service_tenant', $::kickstack::auth_service_tenant),
  $auth_host        = hiera('auth_internal_address', '127.0.0.1'),
  $registry_host    = hiera('glance_registry_host', '127.0.0.1'),
  $glance_backend   = hiera('glance_backend', $::kickstack::glance_backend),
  $verbose          = hiera('verbose', $::kickstack::verbose),
  $debug            = hiera('debug', $::kickstack::debug),
  $management_nic   = hiera('management_nic', $::kickstack::management_nic)
) inherits kickstack {

  include kickstack::glance::config

  $sql_connection_string = "${db_type}://${db_user}:${db_password}@${db_host}/${db_name}"

  class { '::glance::api':
    verbose           => $verbose,
    debug             => $debug,
    auth_type         => 'keystone',
    auth_host         => $auth_host,
    keystone_tenant   => $service_tenant,
    keystone_user     => $service_user,
    keystone_password => $service_password,
    sql_connection    => $sql_connection_string,
    registry_host     => $registry_host,
  }

  data { 'glance_api_host':
    value => get_ip_from_nic($management_nic),
  }

  # this has to be included below glance::api b/c it inherits from it
  # if we include it at the top, then it will not set the params for glance::api
  include "kickstack::glance::backend::${glance_backend}"

}
