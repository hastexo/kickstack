require 'spec_helper'

describe 'kickstack::keystone::api' do

  setup_required_facts

  let :req_params do
    {
      :keystone_db_password      => 'ks_db_pass',
      :keystone_service_password => 'ks_service_pass',
      :admin_token               => 'token',
      :admin_password            => 'admin_pass',
    }
  end
  let :hiera_data do
    req_params
  end
  describe 'with only required parameters' do
    it 'should configure keystone::api' do
      should contain_data('keystone_admin_password').with_value('admin_pass')
      should contain_data('keystone_admin_token').with_value('token')
      should contain_data('auth_internal_address').with_value('11.0.0.1')
      should contain_class('keystone').with({
        :package_ensure => 'present',
        :verbose        => false,
        :debug          => false,
        :catalog_type   => 'sql',
        :admin_token    => 'token',
        :sql_connection => 'mysql://keystone:ks_db_pass@127.0.0.1/keystone',
      })
      should contain_class('keystone::roles::admin').with({
        :email          => 'root@localhost',
        :password       => 'admin_pass',
        :admin_tenant   => 'admin',
        :service_tenant => 'services',
        :require        => 'Class[Keystone::Endpoint]',
      })
    end
  end
  describe 'when overridding parameters' do
    let :hiera_data do
      req_params.merge({
        :verbose          => true,
        :debug            => true,
        :package_ensure   => 'latest',
        :admin_email      => 'dan@foo.bar',
        :service_tenant   => 'services2',
        :admin_tenant     => 'root',
        :keystone_db_name => 'name',
        :keystone_db_user => 'user',
        :db_host          => 'db_host',
        :db_type          => 'postgresql'
      })
    end
    it 'should configure keystone::api' do
      should contain_class('keystone').with({
        :package_ensure => 'latest',
        :verbose        => true,
        :debug          => true,
        :sql_connection => 'postgresql://user:ks_db_pass@db_host/name',
      })
      should contain_class('keystone::roles::admin').with({
        :email          => 'dan@foo.bar',
        :admin_tenant   => 'root',
        :service_tenant => 'services2',
      })
    end

  end

end
