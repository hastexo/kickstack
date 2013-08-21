require 'spec_helper'

describe 'kickstack::memcached' do

  let :facts do
    {
      :osfamily       => 'Debian',
      :memorysize     => '10000',
      :processorcount => 2,
    }
  end

  it { should contain_class('memcached') }

end
