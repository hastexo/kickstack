#
#
class kickstack::nova::vncproxy(
  $public_nic     = hiera('public_nic', $::kickstack::public_nic),
  $package_ensure = hiera('package_ensure', 'present')
) inherits kickstack {

  include kickstack::nova::config

  # Installs the Nova service
  class { "::nova::vncproxy":
    enabled        => true,
    ensure_package => $package_ensure,
    host           => get_ip_from_nic($public_nic),
  }

  data { 'vncproxy_host':
    value => get_ip_from_nic($public_nic),
  }
}
