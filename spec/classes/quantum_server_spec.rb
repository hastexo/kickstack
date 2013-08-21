require 'spec_helper'

describe 'kickstack::quantum::server' do

  setup_required_facts
  setup_required_hiera_data('quantum')

  it 'should configure quantum' do
    should contain_class('kickstack::quantum::config')
    should contain_class('quantum::server').with({
      :auth_tenant   => 'services',
      :auth_user     => 'quantum',
      :auth_password => 'quantum_service_pass',
      :auth_host     => '127.0.0.1',
    })
    should contain_data('quantum_host').with_value(
      '11.0.0.1'
    )
  end

  describe 'when overriding auth host' do

    let :hiera_data do
      req_params.merge(
        {
          :keystone_internal_address => '10.0.0.1',
          :service_tenant            => 'ten10',
          :quantum_service_user              => 'bob',
        })
    end
    it 'should configure quantum' do
      should contain_class('quantum::server').with({
        :auth_tenant   => 'ten10',
        :auth_user     => 'bob',
        :auth_password => 'quantum_service_pass',
        :auth_host     => '10.0.0.1',
      })
    end
  end
end
