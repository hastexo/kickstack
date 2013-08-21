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

  case "$::kickstack::nova_compute_driver" {
    'libvirt': {
      class { '::nova::compute::libvirt':
        libvirt_type => "$::kickstack::nova_compute_libvirt_type",
        vncserver_listen => $vncserver_listen_address
      }
    }
    'xenserver': {
      class { '::nova::compute::xenserver':
        xenapi_connection_url => "$::kickstack::nova_compute_xenapi_connection_url",
        xenapi_connection_username => "$::kickstack::nova_compute_xenapi_connection_username",
        xenapi_connection_password => "$::kickstack::nova_compute_xenapi_connection_password"
      }
    }
  }

}
