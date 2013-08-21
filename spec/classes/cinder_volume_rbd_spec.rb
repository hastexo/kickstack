require 'spec_helper'

describe 'kickstack::cinder::volume::rbd' do

  setup_required_facts
  setup_required_hiera_data('cinder')

  let :hiera_data do
    req_params.merge({
      :rbd_pool        => 'pool',
      :rbd_user        => 'c_user',
      :rbd_secret_uuid => 'ss',
    })
  end

  describe 'with defaults' do
    it 'should configure the cinder rbd backend' do
      should contain_class('kickstack::cinder::config')
      should contain_class('cinder::volume::rbd').with({
        :rbd_pool        => 'pool',
        :rbd_user        => 'c_user',
        :rbd_secret_uuid => 'ss',
      })
    end
  end
end
