require 'spec_helper'

describe 'kickstack::cinder::volume' do

  setup_required_facts
  setup_required_hiera_data('cinder')

  describe 'with default parameters' do

    it 'should configure the base cinder volume class' do
      should contain_class('kickstack::cinder::config')
      should contain_class('kickstack::cinder::volume::iscsi')
      should contain_class('cinder::volume').with({
        :package_ensure => 'present',
      })
    end

  end

  describe 'when overriding more values' do

    let :hiera_data do
      req_params.merge({
        :cinder_backend  => 'rbd',
        :package_ensure  => 'latest',
        :rbd_pool        => 'foo',
        :rbd_secret_uuid => 'bar',
      })
    end

    it 'should configure the base cinder volume class' do
      should contain_class('kickstack::cinder::volume::rbd')
      should contain_class('cinder::volume').with({
        :package_ensure => 'latest',
      })
    end

  end

end
