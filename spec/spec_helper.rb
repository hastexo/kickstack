require 'puppetlabs_spec_helper/module_spec_helper'
require 'hiera-puppet-helper'

def setup_required_facts
  let :facts do
    {
      :osfamily       => 'Debian',
      :ipaddress_eth2 => '11.0.0.1',
    }
  end
end

def required_parameters(type)
  {
    "#{type}_db_password"      => "#{type}_db_pass",
    :rpc_password              => 'rabbit_pass',
    "#{type}_service_password" => "#{type}_service_pass",
  }
end

def setup_required_hiera_data(type)
  let :req_params do
    required_parameters(type)
  end
  let :hiera_data do
    req_params
  end
end

def test_client(type)

  let :facts do
    {
      :osfamily       => 'Debian',
    }
  end

  it 'should include client class' do
    should contain_class("#{type}::client")
  end
end

def test_db(type)

  setup_required_facts

  let :req_params do
    {
      "#{type}_db_password" => 'c_db_p',
    }
  end

  let :hiera_data do
    req_params
  end

  let :pre_condition do
    'include mysql::server'
  end

  it 'should perform default configuration' do

    should contain_class("#{type}::db::mysql").with( {
      :user          => type,
      :dbname        => type,
      :password      => 'c_db_p',
      :charset       => 'utf8',
      :allowed_hosts => false,
    } )

    should contain_data("#{type}_db_password").with( {
      :value => 'c_db_p',
    })

  end

  describe 'with mysql' do
    let :hiera_data do
      req_params.merge( {
        "#{type}_db_user"   => 'pass2',
        "#{type}_db_name"   => 'pass3',
        :db_host            => '10.0.0.3',
        :db_type            => 'mysql',
        :db_allowed_hosts   => '%',
      } )
    end
    it { should contain_class("#{type}::db::mysql").with( {
      :dbname        => 'pass3',
      :user          => 'pass2',
      :password      => 'c_db_p',
      :charset       => 'utf8',
      :allowed_hosts => '%',
    } ) }
  end

  describe 'with postgresql' do
    let :hiera_data do
      req.merge( {
        "#{type}_db_user" => 'pass2',
        "#{type}_db_name" => 'pass3',
        :db_host          => '10.0.0.3',
        :db_type          => 'posgresql',
      } )
      it { should contain_class("#{type}::db::postgresql").with( {
        :db_name  => 'pass3',
        :user     => 'pass2',
        :password => 'c_db_p',
      } ) }
    end
  end
end

def test_endpoint(type)

  let :req_param do
    {
      "#{type}_service_password"  => "#{type}_service_pass",
      "#{type}_public_address"    => '10.10.0.2',
      "#{type}_admin_address"     => '10.11.0.2',
      "#{type}_internal_address"  => '10.12.0.2',
    }
  end

  let :hiera_data do
    req_param
  end

  describe 'with only required parameters' do
    it 'should configure the endpoint and data' do
      should contain_class("#{type}::keystone::auth").with( {
        :password         => "#{type}_service_pass",
        :public_address   => '10.10.0.2',
        :admin_address    => '10.11.0.2',
        :internal_address => '10.12.0.2',
        :region           => 'RegionOne',
        :tenant           => 'services',
        :require          => 'Class[Keystone]',
      } )
      should contain_data("#{type}_service_password").with( {
        :value => "#{type}_service_pass"
      } )
    end
  end

  describe 'when overriding defaults' do

    let :hiera_data do
      req_param.merge( {
        :region         => 'dans_region',
        :service_tenant => 'services2',
      } )
    end
    it {  should contain_class("#{type}::keystone::auth").with( {
        :region           => 'dans_region',
        :tenant           => 'services2',
    } ) }

  end

end

def test_nova_service(service_name)

  setup_required_facts
  setup_required_hiera_data('nova')

  it "should configure nova::#{service_name}" do
    should contain_class('kickstack::nova::config')
    should contain_class("nova::#{service_name}").with({
      :ensure_package => 'present',
      :enabled       => true,
    })
  end

  describe 'when overriding package ensure' do
    let :hiera_data do
      req_params.merge(:package_ensure => 'latest')
    end
    it { should contain_class("nova::#{service_name}").with_ensure_package(
      'latest'
    )}
  end
end
