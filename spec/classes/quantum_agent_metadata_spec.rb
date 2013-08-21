require 'spec_helper'

describe 'kickstack::quantum::agent::metadata' do

  setup_required_facts
  setup_required_hiera_data('quantum')

  describe 'with required params' do

    let :hiera_data do
      req_params.merge({
        :metadata_shared_secret => 'secret',
        :nova_metadata_ip       => '10.0.0.1',
      })
    end

    it 'should configure dhcp agent' do
      should contain_class('kickstack::quantum::config')
      should contain_class('quantum::agents::metadata').with({
        :shared_secret     => 'secret',
        :auth_password     => 'quantum_service_pass',
        :debug             => false,
        :auth_tenant       => 'services',
        :auth_user         => 'quantum',
        :auth_url          => 'http://127.0.0.1:35357/v2.0',
        :auth_region       => 'RegionOne',
        :metadata_ip       => '10.0.0.1',
      })
    end
  end
end
