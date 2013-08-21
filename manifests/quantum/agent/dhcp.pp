#
class kickstack::quantum::agent::dhcp(
  $network_type = hiera('quantum_network_type', 'per-tenant-router'),
  $plugin       = hiera('quantum_plugin', 'ovs'),
  $debug        = hiera('debug', $::kickstack::debug)
) inherits kickstack {

  include kickstack::quantum::config

  $interface_driver =  $plugin ? {
    'ovs'         => 'quantum.agent.linux.interface.OVSInterfaceDriver',
    'linuxbridge' => 'quantum.agent.linux.interface.BridgeInterfaceDriver'
  }

  $use_namespaces = $network_type ? {
    'per-tenant-router' => true,
    default             => false
  }

  class { '::quantum::agents::dhcp':
    debug            => $debug,
    interface_driver => $interface_driver,
    use_namespaces   => $use_namespaces,
  }
}
