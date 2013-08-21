require 'spec_helper'

describe 'kickstack::nova::vncproxy' do

  test_nova_service('vncproxy')
  it { should contain_data('vncproxy_host').with_value(
    '11.0.0.1'
  ) }

end
