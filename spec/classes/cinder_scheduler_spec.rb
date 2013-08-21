require 'spec_helper'

describe 'kickstack::cinder::scheduler' do

  setup_required_facts
  setup_required_hiera_data('cinder')

  it 'should configure the scheduler' do
    should contain_class('cinder::scheduler').with({
    :scheduler_driver => 'cinder.scheduler.simple.SimpleScheduler',
    })
    should contain_class('kickstack::cinder::config')
  end

end
