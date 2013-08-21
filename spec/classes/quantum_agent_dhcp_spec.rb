require 'spec_helper'

describe 'kickstack::quantum::agent::dhcp' do

  setup_required_facts
  setup_required_hiera_data('quantum')


  it 'should configure dhcp agent' do
    should contain_class('kickstack::quantum::config')
    should contain_class('quantum::agents::dhcp').with({
      :debug            => false,
      :interface_driver => 'quantum.agent.linux.interface.OVSInterfaceDriver',
      :use_namespaces   => true,
    })
  end

  describe 'when overriding params' do
    let :hiera_data do
      req_params.merge({
        :quantum_network_type => 'single-flat',
        :quantum_plugin       => 'linuxbridge',
        :debug                => true,
      })
    end
    it 'should configure dhcp agent' do
      should contain_class('quantum::agents::dhcp').with({
        :debug            => true,
        :interface_driver => 'quantum.agent.linux.interface.BridgeInterfaceDriver',
        :use_namespaces   => false,
      })
    end

  end
end
