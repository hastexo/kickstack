require 'spec_helper'

describe 'kickstack::quantum::config' do

  setup_required_hiera_data('quantum')

  describe 'should configure rabbitmq with defaults' do
    let :facts do
      {
        :osfamily       => 'Debian',
        :ipaddress_eth2 => '11.0.0.1',
      }
    end
    it { should contain_class('quantum').with( {
      :rpc_backend           => 'quantum.openstack.common.rpc.impl_kombu',
      :rabbit_host           => '127.0.0.1',
      :rabbit_user           => 'openstack',
      :rabbit_password       => 'rabbit_pass',
      :verbose               => false,
      :debug                 => false,
      :allow_overlapping_ips => false,
      :core_plugin           => 'quantum.plugins.openvswitch.ovs_quantum_plugin.OVSQuantumPluginV2',
    } ) }
  end

  describe 'when overriding params' do
    let :hiera_data do
      req_params.merge({
        :rpc_host             => '10.0.0.3',
        :rpc_user             => 'rabbit',
        :quantum_network_type => 'per-tenant-router',
        :quantum_plugin       => 'linuxbridge',
        :verbose              => true,
        :debug                => true,
      })
    end
    let :facts do
      {
        :osfamily       => 'Debian',
        :ipaddress_eth2 => '11.0.0.1',
      }
    end
    it { should contain_class('quantum').with( {
      :rpc_backend           => 'quantum.openstack.common.rpc.impl_kombu',
      :rabbit_host           => '10.0.0.3',
      :rabbit_user           => 'rabbit',
      :rabbit_password       => 'rabbit_pass',
      :verbose               => true,
      :debug                 => true,
      :allow_overlapping_ips => true,
      :core_plugin           => 'quantum.plugins.linuxbridge.lb_quantum_plugin.LinuxBridgePluginV2',
    } ) }
  end

  describe 'should configure qpid with defaults' do
    let :facts do
      {
        :osfamily        => 'RedHat',
        :operatingsystem => 'RedHat',
        :ipaddress_eth2  => '11.0.0.1',
      }
    end
    it { should contain_class('quantum').with( {
      :rpc_backend           => 'quantum.openstack.common.rpc.impl_qpid',
      :qpid_hostname         => '127.0.0.1',
      :qpid_username         => 'openstack',
      :qpid_password         => 'rabbit_pass',
      :verbose               => false,
      :debug                 => false,
      :allow_overlapping_ips => false,
      :core_plugin           => 'quantum.plugins.openvswitch.ovs_quantum_plugin.OVSQuantumPluginV2',
    } ) }
  end

end

