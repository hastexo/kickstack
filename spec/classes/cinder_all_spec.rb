require 'spec_helper'

describe 'kickstack::cinder::all' do

  setup_required_facts
  setup_required_hiera_data('cinder')

  it 'should include the cinder classes' do
    should contain_class('kickstack::cinder::controller')
    should contain_class('kickstack::cinder::volume')
  end

end
