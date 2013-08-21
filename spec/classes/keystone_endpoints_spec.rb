require 'spec_helper'

describe 'kickstack::keystone::endpoints' do

  setup_required_facts

  let :req_params do
    {
      :keystone_db_password      => 'ks_db_pass',
      :keystone_service_password => 'ks_service_pass',
      :admin_token               => 'token',
      :admin_password            => 'admin_pass',
      :cinder_service_password   => 'cinder_service_pass',
      :cinder_public_address     => '127.0.0.1',
      :glance_service_password   => 'glance_service_pass',
      :glance_public_address     => '127.0.0.1',
      :nova_service_password     => 'nova_service_pass',
      :nova_public_address       => '127.0.0.1',
      :quantum_service_password  => 'quantum_service_pass',
      :quantum_public_address    => '127.0.0.1',
      :swift_service_password    => 'swift_service_pass',
      :swift_public_address      => '127.0.0.1',
      :auth_public_address       => '127.0.0.1',
      :auth_service_password     => 'keystone_pass',
    }
  end

  let :hiera_data do
    req_params
  end

  describe 'with only required parameters' do
    it 'should configure endpoints' do
      ['cinder', 'glance', 'nova', 'quantum'].each do |x|
        should contain_class("kickstack::#{x}::endpoint")
      end
      should_not contain_class('kickstack::swift::endpoint')
    end
  end

  describe 'when enabling swift' do
    let :hiera_data do
      req_params.merge(:enable_swift => true)
    end
    it 'should configure swift endpoints' do
      should contain_class('kickstack::swift::endpoint')
    end
  end

  ['cinder', 'glance', 'nova', 'quantum'].each do |y|
    describe "when disabling #{y}" do
      let :hiera_data do
        req_params.merge("enable_#{y}" => false)
      end
      it { should_not contain_class("kickstack::#{y}::endpoint") }
    end

  end

end
