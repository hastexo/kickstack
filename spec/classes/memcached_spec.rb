require 'spec_helper'

describe 'kickstack::memcached' do

  let :facts do
    {:osfamily => 'Debian'}
  end

  it { should contain_package('memcached').with_ensure('installed')}

end
