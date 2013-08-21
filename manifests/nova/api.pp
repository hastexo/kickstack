#
class kickstack::nova::api(
  $service_password = hiera('nova_service_password'),
  $service_user     = hiera('nova_service_user', 'nova'),
  $service_tenant   = hiera('service_tenant', 'services'),
  $auth_host        = hiera('auth_internal_address', '127.0.0.1'),
  $quantum_secret   = hiera('metadata_shared_secret'),
  $management_nic   = hiera('management_nic', $::kickstack::management_nic)
) inherits kickstack {

  include kickstack::nova::config

  # Stupid hack: Grizzly packages in Ubuntu Cloud Archive
  # require python-eventlet > 0.9, but the python-nova
  # package in UCA does not reflect this
  package { 'python-eventlet':
    ensure => latest
  }

  class { '::nova::api':
    enabled           => true,
    auth_strategy     => 'keystone',
    auth_host         => $auth_host,
    admin_tenant_name => $service_tenant,
    admin_user        => $service_user,
    admin_password    => $service_password,
    enabled_apis      => 'ec2,osapi_compute,metadata',
    quantum_metadata_proxy_shared_secret => $quantum_secret,
  }

  data { 'nova_metadata_ip':
    value => get_ip_from_nic($management_nic),
  }
  data { 'quantum_metadata_shared_secret':
    value => $quantum_secret,
  }

}
