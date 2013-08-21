#
class kickstack::glance::registry(
  $management_nic   = hiera('management_nic', $::kickstack::management_nic)
) inherits kickstack {

  include kickstack::glance::config

  $service_password = getvar("${fact_prefix}glance_keystone_password")
  $sql_conn = getvar("${fact_prefix}glance_sql_connection")
  $keystone_internal_address = getvar("${fact_prefix}keystone_internal_address")

  class { '::glance::registry':
    verbose           => $kickstack::verbose,
    debug             => $kickstack::debug,
    auth_host         => "$keystone_internal_address", 
    keystone_tenant   => "$keystone_service_tenant",
    keystone_user     => 'glance',
    keystone_password => "$service_password",
    sql_connection    => "$sql_conn",
  }

  # Export the registry host name string for the service
  data { 'glance_registry_host':
    value => get_ip_from_nic($management_nic),
  }

}
