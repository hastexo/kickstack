require 'spec_helper'

describe 'kickstack::keystone::all' do

  setup_required_facts

  let :hiera_data do
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
    }
  end

  it 'should include the cinder classes' do
    ['api', 'endpoints']. each do |x|
      should contain_class("kickstack::keystone::#{x}")
    end
  end
end
