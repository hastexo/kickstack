require 'spec_helper'

describe 'kickstack::cinder::controller' do

  setup_required_facts
  setup_required_hiera_data('cinder')

  it 'should include the cinder controller classes' do
    ['config', 'api', 'scheduler'].each do |x|
      should contain_class("kickstack::cinder::#{x}")
    end
  end

end
