#
class kickstack::quantum::agent::metadata(
  $shared_secret    = hiera('metadata_shared_secret'),
  $service_password = hiera('quantum_service_password'),
  $metadata_ip      = hiera('nova_metadata_ip'),
  $auth_host        = hiera('auth_internal_address', '127.0.0.1'),
  $debug            = hiera('debug', $::kickstack::debug),
  $service_tenant   = hiera('service_tenant', 'services'),
) inherits kickstack {

  include kickstack::quantum::config

  class { '::quantum::agents::metadata':
    shared_secret     => $shared_secret,
    auth_password     => $service_password,
    debug             => $debug,
    auth_tenant       => $service_tenant,
    auth_user         => 'quantum',
    auth_url          => "http://${auth_host}:35357/v2.0",
    auth_region       => $::kickstack::auth_region,
    metadata_ip       => $metadata_ip,
  }

}
