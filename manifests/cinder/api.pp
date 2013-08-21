# Configures the cinder api service
#
# == Parameters
#
class kickstack::cinder::api(
  $service_password    = hiera('cinder_service_password'),
  $service_user        = hiera('cinder_service_user', 'cinder'),
  $auth_service_tenant = hiera('auth_service_tenant', $::kickstack::auth_service_tenant),
  $auth_host           = hiera('auth_internal_address', '127.0.0.1'),
  $package_ensure      = hiera('package_ensure', 'present')
) inherits kickstack {

  include kickstack::cinder::config

  class { '::cinder::api':
    keystone_tenant    => $auth_service_tenant,
    keystone_user      => $service_user,
    keystone_password  => $service_password,
    keystone_auth_host => $auth_host,
    package_ensure     => $package_ensure,
  }

}
