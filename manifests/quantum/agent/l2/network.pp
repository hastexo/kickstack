#
class kickstack::quantum::agent::l2::network(
  $tenant_network_type = hiera('tenant_network_type', 'gre'),
  $network_type        = hiera('network_type', 'ovs', 'single-flat'),
  $plugin              = hiera('network_plugin', 'ovs'),
  $data_nic            = hiera('data_nic'),
  $external_nic        = hiera('external_nic'),
  $physnet             = hiera('quantum_physnet', 'default'),
  $integration_bridge  = hiera('intergration_bridge', 'br-int'),
  $external_bridge     = hiera('quantum_external_bridge', 'br-ex'),
  $tunnel_bridge       = hiera('quantum_tunnel_bridge', 'br-tun'),
) inherits kickstack {

  include kickstack::quantum::config

  case $plugin {
    'ovs': {
      case $tenant_network_type {
        'gre': {
          $local_tunnel_ip = get_ip_from_nic($data_nic)
          $bridge_uplinks = ["${external_bridge}:${external_nic}"]

          # The quantum module creates bridge_uplinks only when
          # bridge_mappings is non-empty. That's bogus for GRE
          # configurations, so create the uplink anyway.
          #::quantum::plugins::ovs::port { $bridge_uplinks: }
          class { 'quantum::agents::ovs':
            bridge_uplinks     => $bridge_uplinks,
            bridge_mappings    => ["${physnet}:${external_bridge}"],
            integration_bridge => $integration_bridge,
            enable_tunneling   => true,
            local_ip           => $local_tunnel_ip,
            tunnel_bridge      => $tunnel_bridge,
          }
        }
        default: {
          # TODO is this correct? It does not look right?
          $bridge_uplinks = ["br-${data_nic}:${data_nic}"]
          unless $network_type == 'single-flat' {
            $bridge_uplinks += ["${external_bridge}:${external_nic}"]
          }
          class { 'quantum::agents::ovs':
            bridge_mappings    => ["${physnet}:br-${data_nic}"],
            bridge_uplinks     => $bridge_uplinks,
            integration_bridge => $integration_bridge,
            enable_tunneling   => false,
            local_ip           => '',
          }
        }
      }
    }
    'linuxbridge': {
      class { 'quantum::agents::linuxbridge':
        physical_interface_mappings => "default:${data_nic}"
      }
    }
  }
}
