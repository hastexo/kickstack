#
class kickstack::quantum::config(
  $rpc_host     = hiera('rpc_host', '127.0.0.1'),
  $rpc_user     = hiera('rpc_user', 'openstack'),
  $rpc_type     = hiera('rpc_type', $::kickstack::rpc_type),
  $rpc_password = hiera('rpc_password'),
  $network_type = hiera('quantum_network_type', 'single-flat'),
  $plugin       = hiera('quantum_plugin', 'ovs'),
  $verbose      = hiera('verbose', $::kickstack::verbose),
  $debug        = hiera('debug', $::kickstack::debug),
) inherits kickstack {

  $allow_overlapping_ips = $network_type ? {
    'single-flat'       => false,
    'provider-router'   => false,
    'per-tenant-router' => true,
  }

  $core_plugin = $plugin ? {
    'ovs' => 'quantum.plugins.openvswitch.ovs_quantum_plugin.OVSQuantumPluginV2',
    'linuxbridge'=> 'quantum.plugins.linuxbridge.lb_quantum_plugin.LinuxBridgePluginV2'
  }

  case $rpc_type {
    'rabbitmq': {
      class { 'quantum':
        rpc_backend           => 'quantum.openstack.common.rpc.impl_kombu',
        rabbit_host           => $rpc_host,
        rabbit_user           => $rpc_user,
        rabbit_password       => $rpc_password,
        verbose               => $verbose,
        debug                 => $debug,
        allow_overlapping_ips => $allow_overlapping_ips,
        core_plugin           => $core_plugin,
      }
    }
    'qpid': {
      class { 'quantum':
        rpc_backend           => 'quantum.openstack.common.rpc.impl_qpid',
        qpid_hostname         => $rpc_host,
        qpid_username         => $rpc_user,
        qpid_password         => $rpc_password,
        verbose               => $verbose,
        debug                 => $debug,
        allow_overlapping_ips => $allow_overlapping_ips,
        core_plugin           => $core_plugin,
      }
    }
    default: {
      fail("Unsupported rpc_type: ${rpc_type}")
    }
  }
}
