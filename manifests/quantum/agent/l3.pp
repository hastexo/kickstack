#
class kickstack::quantum::agent::l3(
  $network_type       = hiera('quantum_network_type', 'per-tenant-router'),
  $plugin             = hiera('quantum_plugin', 'ovs'),
  $external_bridge    = hiera('quantum_external_bridge', 'br-ex'),
#  $router_id          = hiera('quantum_router_id', undef),
#  $gateway_ext_net_id = hiera('quantum_gw_ext_net_id', undef),
) inherits kickstack {

  include kickstack::quantum::config

  #vs_bridge { $external_bridge:
  #  ensure => present,
  #}

  $interface_driver = $plugin ? {
    'ovs'         => 'quantum.agent.linux.interface.OVSInterfaceDriver',
    'linuxbridge' => 'quantum.agent.linux.interface.BridgeInterfaceDriver'
  }
  $use_namespaces = $network_type ? {
    'per-tenant-router' => true,
    default             => false
  }
  #$router_id = $network_type ? {
  #  'provider-router' => $router_id,
  #  default => undef
  #}
  #$gateway_external_network_id = $network_type ? {
  #  'provider-router' => $gateway_external_network_id,
  #  default           => undef
  #}

  class { '::quantum::agents::l3':
    debug                       => $::kickstack::debug,
    interface_driver            => $interface_driver,
    external_network_bridge     => $external_bridge,
    use_namespaces              => $use_namespaces,
    router_id                   => $router_id,
    gateway_external_network_id => $gateway_external_network_id,
    require                     => Class[
      'kickstack::quantum::agent::metadata',
      'vswitch::ovs'
    ]
  }
}
