require 'spec_helper'

describe 'kickstack::nova::vncproxy' do

  setup_required_facts
  setup_required_hiera_data('nova')

  describe 'with public_nic' do
    let :hiera_data do
      req_params.merge(:public_nic => 'eth2')
    end
    it "should configure nova::vncproxy" do
      should contain_class('kickstack::nova::config')
      should contain_class("nova::vncproxy").with({
        :ensure_package => 'present',
        :enabled       => true,
      })
      should contain_data('vncproxy_host').with_value(
        '11.0.0.1'
      )
    end
  end

  describe 'when overriding package ensure' do
    let :hiera_data do
      req_params.merge(:package_ensure => 'latest', :public_nic => 'eth2')
    end
    it { should contain_class("nova::vncproxy").with_ensure_package(
      'latest'
    )}
  end

end
