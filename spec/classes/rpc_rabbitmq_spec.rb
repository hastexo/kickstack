require 'spec_helper'

describe 'kickstack::rpc::rabbitmq' do

  setup_required_facts
  let :hiera_data do
    {
      :rpc_password          => 'pass',
      :rpc_user              => 'user',
      :rabbitmq_virtual_host => 'realm',
    }
  end

  it 'should configure rabbitmq' do
    should contain_class('nova::rabbitmq').with({
      :userid       => 'user',
      :password     => 'pass',
      :virtual_host => 'realm',
    })
    should contain_data('rpc_host').with_value(
      '11.0.0.1'
    )
    should contain_data('rpc_password').with_value(
      'pass'
    )
  end

end
