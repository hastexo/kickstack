require 'spec_helper'

describe 'kickstack::cinder::api' do

  setup_required_facts
  setup_required_hiera_data('cinder')

  describe 'with only default parameters' do

    it 'should use defaults' do
      should contain_class('cinder::api').with( {
        :keystone_tenant    => 'services',
        :keystone_user      => 'cinder',
        :keystone_password  => 'cinder_service_pass',
        :keystone_auth_host => '127.0.0.1',
      } )
    end

  end

  describe 'when overriding data from hiera' do

    #
    # I cannot override things in before, b/c the hiera data gets
    # set in the global before block which happens before
    #
    let :hiera_data do
      req_params.merge( {
        :auth_service_tenant   => 'services2',
        :cinder_service_user   => 'cinder2',
        :auth_internal_address => '10.0.0.1',
      } )

    end

    it 'should allow data to be overridden from hiera' do
      should contain_class('cinder::api').with( {
        :keystone_tenant    => 'services2',
        :keystone_user      => 'cinder2',
        :keystone_auth_host => '10.0.0.1',
      } )
    end
  end
end
