require 'spec_helper'

describe 'kickstack::cinder::config' do

  setup_required_hiera_data('cinder')

  describe 'should configure rabbitmq with defaults' do
    let :facts do
      {
        :osfamily       => 'Debian',
        :ipaddress_eth2 => '11.0.0.1',
      }
    end
    it { should contain_class('cinder').with( {
      :sql_connection  => 'mysql://cinder:cinder_db_pass@127.0.0.1/cinder',
      :rpc_backend     => 'cinder.openstack.common.rpc.impl_kombu',
      :rabbit_host     => '127.0.0.1',
      :rabbit_userid   => 'openstack',
      :rabbit_password => 'rabbit_pass',
      :verbose         => false,
      :debug           => false,
    } ) }
  end

  describe 'should configure qpid with defaults' do
    let :facts do
      {
        :osfamily        => 'RedHat',
        :operatingsystem => 'RedHat',
        :ipaddress_eth2  => '11.0.0.1',
      }
    end
    it { should contain_class('cinder').with( {
      :sql_connection => 'mysql://cinder:cinder_db_pass@127.0.0.1/cinder',
      :rpc_backend    => 'cinder.openstack.common.rpc.impl_qpid',
      :qpid_hostname  => '127.0.0.1',
      :qpid_username  => 'openstack',
      :qpid_password  => 'rabbit_pass',
      :verbose        => false,
      :debug          => false,
    } ) }
  end

end

