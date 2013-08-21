require 'spec_helper'

describe 'kickstack::glance::api' do

  setup_required_facts
  setup_required_hiera_data('glance')

  describe 'with only required parameters' do

    it 'should configure glance api service' do
      should contain_class('kickstack::glance::config')
      should contain_class('glance::api').with({
        :verbose           => false,
        :debug             => false,
        :auth_type         => 'keystone',
        :auth_host         => '127.0.0.1',
        :keystone_tenant   => 'services',
        :keystone_user     => 'glance',
        :keystone_password => 'glance_service_pass',
        :sql_connection    => 'mysql://glance:glance_db_pass@127.0.0.1/glance',
        :registry_host     => '127.0.0.1',
      })
      should contain_class('kickstack::glance::backend::file')
      should contain_data('glance_api_host').with_value(
        '11.0.0.1'
      )
    end

  end

  describe 'when overriding hiera data' do

    let :hiera_data do
      req_params.merge({
        :glance_db_user        => 'user2',
        :glance_db_name        => 'name2',
        :db_host               => '11.0.0.5',
        :db_type               => 'postgresql',
        :glance_service_user   => 'user2',
        :service_tenant        => 'services2',
        :auth_internal_address => '11.0.0.3',
        :glance_registry_host  => '11.0.0.2',
        :verbose               => true,
        :debug                 => true,
      })
    end
    it 'should configure glance api service' do
      should contain_class('kickstack::glance::config')
      should contain_class('glance::api').with({
        :verbose           => true,
        :debug             => true,
        :auth_host         => '11.0.0.3',
        :keystone_tenant   => 'services2',
        :keystone_user     => 'user2',
        :keystone_password => 'glance_service_pass',
        :sql_connection    => 'postgresql://user2:glance_db_pass@11.0.0.5/name2',
        :registry_host     => '11.0.0.2',
      })
    end
  end
end
