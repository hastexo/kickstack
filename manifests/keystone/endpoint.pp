# define resource type that helps populate keystone endpoints
# for all of the services
#
class kickstack::keystone::endpoint (
  $service_password         = hiera("keystone_service_password"),
  # is this crazy to nest hiera calls like this?
  $service_public_address   = hiera("keystone_public_address"),
  $service_admin_address    = hiera("keystone_admin_address", hiera("keystone_public_address")),
  $service_internal_address = hiera("keystone_internal_address", hiera("keystone_public_address")),
  $service_tenant           = hiera('service_tenant', 'services'),
  $service_region           = hiera('region', 'RegionOne'),
) {

  class { "::keystone::endpoint":
    public_address   => $service_public_address,
    admin_address    => $service_admin_address,
    internal_address => $service_internal_address,
    region           => $service_region,
    require          => Class['::keystone'],
  }

  data { "keystone_service_password":
    value => $service_password,
  }

}
