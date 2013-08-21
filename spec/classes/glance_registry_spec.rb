require 'spec_helper'

describe 'kickstack::glance::registry' do

  setup_required_facts
  setup_required_hiera_data('glance')

  describe 'with only required parameters' do
    it 'should configure glance registry' do
      should contain_class('kickstack::glance::config')
      should contain_class('glance::registry').with({
        :verbose           => false,
        :debug             => false,
        :auth_host         => '127.0.0.1',
        :keystone_tenant   => 'services',
        :keystone_user     => 'glance',
        :keystone_password => 'glance_service_pass',
        :sql_connection    => 'mysql://glance:glance_db_pass@127.0.0.1/glance',
      })
      should contain_data('glance_registry_host').with_value(
        '11.0.0.1'
      )
    end
  end

  describe 'when overriding parameters' do

    let :hiera_data do
      req_params.merge({
        :glance_db_user        => 'user6',
        :glance_db_name        => 'name9',
        :db_host               => '13.0.0.4',
        :db_type               => 'postgresql',
        :glance_service_user   => 'services8',
        :service_tenant        => 'tenant4',
        :auth_internal_address => '15.0.0.5',
        :verbose               => true,
        :debug                 => true,
      })
    end
    it { should contain_class('glance::registry').with({
      :verbose           => true,
      :debug             => true,
      :auth_host         => '15.0.0.5',
      :keystone_tenant   => 'tenant4',
      :keystone_user     => 'services8',
      :sql_connection    => 'postgresql://user6:glance_db_pass@13.0.0.4/name9',
    })}
  end
end
