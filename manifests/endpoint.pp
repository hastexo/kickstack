#
# define resource type that helps populate keystone endpoints
# for all of the services
#
define kickstack::endpoint (
  $service_password         = hiera("${name}_service_password"),
  $service_public_address   = hiera("${name}_public_address"),
  $service_admin_address    = hiera("${name}_admin_address", hiera("${name}_public_address")),
  $service_internal_address = hiera("${name}_internal_address", hiera("${name}_public_address")),
  $service_tenant           = hiera('service_tenant', 'services'),
  $service_region           = hiera('region', 'RegionOne'),
) {

  class { "${name}::keystone::auth":
    password         => $service_password,
    public_address   => $service_public_address,
    admin_address    => $service_admin_address,
    internal_address => $service_internal_address,
    region           => $service_region,
    tenant           => $service_tenant,
    require          => Class['::keystone'],
  }

  data { "${name}_service_password":
    value => $service_password,
  }

}
