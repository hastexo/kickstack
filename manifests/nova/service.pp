#
# helper class for defining nova services
#
define kickstack::nova::service(
  $package_ensure = hiera('package_ensure', 'present')
) {

  include kickstack::nova::config

  # Installs the Nova service
  class { "::nova::${name}":
    enabled        => true,
    ensure_package => $package_ensure,
  }
}
