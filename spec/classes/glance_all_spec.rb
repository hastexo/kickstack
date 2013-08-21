require 'spec_helper'

describe 'kickstack::glance::all' do

  setup_required_facts
  setup_required_hiera_data('glance')

  it 'should include the cinder classes' do
    ['api', 'config', 'backend::file', 'registry']. each do |x|
      should contain_class("kickstack::glance::#{x}")
    end
  end

end
