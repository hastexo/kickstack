require 'spec_helper'

describe 'kickstack::nova::config' do

  setup_required_hiera_data('nova')

  describe 'should configure rabbitmq with defaults' do
    let :facts do
      {
        :osfamily       => 'Debian',
        :ipaddress_eth2 => '11.0.0.1',
      }
    end
    it { should contain_class('nova').with( {
      :sql_connection     => 'mysql://nova:nova_db_pass@127.0.0.1/nova',
      :rpc_backend        => 'nova.openstack.common.rpc.impl_kombu',
      :rabbit_host        => '127.0.0.1',
      :rabbit_userid      => 'openstack',
      :rabbit_password    => 'rabbit_pass',
      :verbose            => false,
      :debug              => false,
      :glance_api_servers => ['127.0.0.1:9292'],
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
    it { should contain_class('nova').with( {
      :sql_connection => 'mysql://nova:nova_db_pass@127.0.0.1/nova',
      :rpc_backend    => 'nova.openstack.common.rpc.impl_qpid',
      :qpid_hostname  => '127.0.0.1',
      :qpid_username  => 'openstack',
      :qpid_password  => 'rabbit_pass',
      :verbose        => false,
      :debug          => false,
      :glance_api_servers => ['127.0.0.1:9292'],
    } ) }
  end

end

