require 'spec_helper'

describe 'kickstack::glance::config' do

  setup_required_facts
  setup_required_hiera_data('glance')

  it { should contain_class('glance').with_package_ensure(
    'present'
  )}

end
