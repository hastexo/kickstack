#
class kickstack::quantum::plugin(
  $db_password         = hiera('quantum_db_password'),
  $db_user             = hiera('quantum_db_user', 'quantum'),
  $db_name             = hiera('quantum_db_name', 'quantum'),
  $db_host             = hiera('db_host', '127.0.0.1'),
  $db_type             = hiera('db_type', $::kickstack::db_type),
  $tenant_network_type = hiera('tenant_network_type', 'gre'),
  $quantum_physnet     = hiera('physnet', 'physnet1'),
  $vlan_ranges         = hiera('vlan_ranges', '1000:2000'),
  $tunnel_id_ranges    = hiera('tunnel_id_ranges', '1:1000'),
  $plugin              = hiera('network_plugin', 'ovs'),
) inherits kickstack {

  include kickstack::quantum::config

  $sql_connection_string = "${db_type}://${db_user}:${db_password}@${db_host}/${db_name}"

  if $tenant_network_type != 'gre' {
    $network_vlan_ranges = "${physnet}:${vlan_ranges}"
  }

  case $plugin {
    'ovs': {
      class { 'quantum::plugins::ovs':
        sql_connection      => $sql_connection_string,
        tenant_network_type => $tenant_network_type,
        #network_vlan_ranges => $vlan_ranges,
        tunnel_id_ranges    => $tunnel_id_ranges
      }
      # This needs to be set for the plugin, not the agent
      # (the latter is what the Quantum module assumes)
      #quantum_plugin_ovs { 'SECURITYGROUP/firewall_driver':
      #  value   => 'quantum.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver',
      #  require => Class['quantum::plugins::ovs']
      #}
    }
    'linuxbridge': {
      class { 'quantum::plugins::linuxbridge':
        sql_connection      => $sql_connection_string,
        tenant_network_type => $tenant_network_type,
        network_vlan_ranges => $vlan_ranges,
      }
    }
    default: {
      fail("Unsupported quantum plugin: ${plugin}")
    }
  }
}
