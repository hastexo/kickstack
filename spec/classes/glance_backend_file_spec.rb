require 'spec_helper'

describe 'kickstack::glance::backend::file' do

  setup_required_facts
  setup_required_hiera_data('glance')

  it { should contain_class('glance::backend::file') }

end
