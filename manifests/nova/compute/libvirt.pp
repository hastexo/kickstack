#
class kickstack::nova::compute::libvirt(
  $libvirt_type     = hiera('libvirt_type', 'kvm'),
  $vncserver_listen = hiera('vncserver_listen', '127.0.0.1'),
) inherits kickstack {

  include kickstack::nova::config

  class { '::nova::compute::libvirt':
    libvirt_type     => $libvirt_type,
    vncserver_listen => $vncserver_listen,
  }
}
