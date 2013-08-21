require 'spec_helper'

describe 'kickstack::glance::backend::swift' do

  setup_required_facts
  #setup_required_hiera_data('glance')

  let :hiera_data do
    {
      :swfit_store_key          => 'key123',
      :swift_store_user         => 'user45',
      :swift_store_auth_address => '12.0.0.1',
    }
  end

  it { should contain_class('glance::backend::swift').with({
    :swift_store_user                    => 'user45',
    :swift_store_key                     => 'key123',
    :swift_store_auth_address            => '12.0.0.1',
    :swift_store_create_container_on_put => true,
  })}

end
