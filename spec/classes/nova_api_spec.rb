require 'spec_helper'

describe 'kickstack::nova::api' do

  setup_required_facts
  setup_required_hiera_data('nova')

  describe 'with only required parameters' do
    let :hiera_data do
      req_params.merge(:metadata_shared_secret => 'secret')
    end
    it 'should configure nova api' do
      should contain_package('python-eventlet').with(
        :ensure => 'latest'
      )
      should contain_data('nova_metadata_ip').with_value(
        '11.0.0.1'
      )
      should contain_data('quantum_metadata_shared_secret').with_value(
        'secret'
      )
      should contain_class('nova::api').with({
        :enabled           => true,
        :auth_strategy     => 'keystone',
        :auth_host         => '127.0.0.1',
        :admin_tenant_name => 'services',
        :admin_user        => 'nova',
        :admin_password    => 'nova_service_pass',
        :enabled_apis      => 'ec2,osapi_compute,metadata',
        :quantum_metadata_proxy_shared_secret => 'secret',
      })
    end
 end

end
