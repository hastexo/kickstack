#
class kickstack::nova::quantumclient(
  $auth_host             = hiera('auth_internal_address', '127.0.0.1'),
  $quantum_auth_password = hiera('quantum_service_password'),
  $quantum_auth_username = hiera('quantum_service_username', 'quantum'),
  $quantum_host          = hiera('quantum_internal_address', '127.0.0.1'),
) inherits kickstack {

  include kickstack::nova::config

  class { '::nova::network::quantum':
    quantum_admin_password    => $quantum_auth_password,
    quantum_auth_strategy     => 'keystone',
    quantum_url               => "http://${quantum_host}:9696",
    quantum_admin_tenant_name => $::kickstack::auth_service_tenant,
    quantum_region_name       => $::kickstack::auth_region,
    quantum_admin_username    => $quantum_auth_username,
    quantum_admin_auth_url    => "http://${auth_host}:35357/v2.0",
    security_group_api        => 'quantum',
  }
}
