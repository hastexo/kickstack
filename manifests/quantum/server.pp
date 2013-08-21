#
class kickstack::quantum::server(
  $management_nic   = hiera('management_nic', $::kickstack::management_nic),
) inherits kickstack {

  include kickstack::quantum::config
  include pwgen

  $service_password = pick(getvar("${fact_prefix}quantum_keystone_password"),pwgen())
  $keystone_internal_address = getvar("${fact_prefix}keystone_internal_address")

  class { '::quantum::server':
    auth_tenant   => $kickstack::keystone_service_tenant,
    auth_user     => 'quantum',
    auth_password => $service_password,
    auth_host     => $auth_host,
  }

  data { 'quantum_host':
    value => get_ip_from_nic($management_nic),
  }

}
