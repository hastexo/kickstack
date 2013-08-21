require 'spec_helper'

describe 'kickstack::rpc::qpid' do

  setup_required_facts

  let :hiera_data do
    {
      :rpc_password => 'pass',
      :rpc_user     => 'user',
      :qpid_realm   => 'realm',
    }
  end

  it 'should configure qpid' do
    should contain_class('nova::qpid').with({
      :user     => 'user',
      :password => 'pass',
      :realm    => 'realm',
    })
    should contain_data('rpc_host').with_value(
      '11.0.0.1'
    )
    should contain_data('rpc_password').with_value(
      'pass'
    )
  end
end
