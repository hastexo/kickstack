#
# base class for configuring nova compute nodes
#
class kickstack::nova::compute(
  $vncproxy_host                 = hiera('vncproxy_host', '127.0.0.1'),
  $vncserver_proxyclient_address = hiera('vncserver_proxyclient_address', '127.0.0.1'),
  $nova_compute_type             = hiera('nova_compute_type', 'libvirt')
) inherits kickstack {

  include kickstack::nova::config
  include "kickstack::nova::compute::${nova_compute_type}"

  class { '::nova::compute':
    enabled                       => true,
    vnc_enabled                   => true,
    vncserver_proxyclient_address => $vncserver_proxyclient_address,
    vncproxy_host                 => $vncproxy_host,
    virtio_nic                    => true,
  }

}
