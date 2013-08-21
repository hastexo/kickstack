require 'spec_helper'

describe 'kickstack::nova::compute' do

  setup_required_facts
  setup_required_hiera_data('nova')

  describe 'with default params' do
    it 'should configure nova' do
      should contain_class('kickstack::nova::config')
      should contain_class('kickstack::nova::compute::libvirt')
      should contain_class('nova::compute').with({
        :enabled                       => true,
        :vnc_enabled                   => true,
        :vncserver_proxyclient_address => '127.0.0.1',
        :vncproxy_host                 => '127.0.0.1',
        :virtio_nic                    => true,
      })
    end
  end
end
