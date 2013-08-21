#
#
class kickstack::nova::vncproxy(
  $public_nic     = hiera('public_nic', $::kickstack::public_nic),
) inherits kickstack {

  include kickstack::nova::config

  kickstack::nova::service { 'vncproxy': }

  data { 'vncproxy_host':
    value => get_ip_from_nic($public_nic),
  }
}
