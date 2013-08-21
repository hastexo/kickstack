require 'spec_helper'

describe 'kickstack::glance::backend::rbd' do

  setup_required_facts

  let :hiera_data do
    {
      :glance_rbd_user => 'user5',
      :glance_rbd_pool => 'pooley',
    }
  end
  it { should contain_class('glance::backend::rbd').with({
    :rbd_store_user => 'user5',
    :rbd_store_pool => 'pooley',
  } ) }

end
