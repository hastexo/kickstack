require 'spec_helper'

describe 'kickstack::horizon' do

  let :req_params do
    {:horizon_secret_key => 'secret'}
  end

  let :facts do
    {
      :osfamily               => 'Debian',
      :ipaddress_eth2         => '11.0.0.1',
      :operatingsystemrelease => '6',
      :concat_basedir         => '/tmp',
    }
  end

  let :hiera_data do
    {:horizon_secret_key => 'secret'}
    #req_params
  end

  it 'should configure horizon' do
    should contain_class('kickstack::memcached')
    should contain_class('horizon').with({
      :secret_key            => 'secret',
      :cache_server_ip       => '127.0.0.1',
      :cache_server_port     => '11211',
      :swift                 => false,
      :quantum               => true,
      :keystone_host         => '127.0.0.1',
      :keystone_default_role => 'Member',
      :django_debug          => 'False',
      :api_result_limit      => 1000,
      :log_level             => 'WARNING',
      :can_set_mount_point   => 'True',
      :listen_ssl            => false,
      :require               => 'Package[memcached]',
    })
    should contain_data('horizon_secret_key').with_value(
      'secret'
    )
  end
end
