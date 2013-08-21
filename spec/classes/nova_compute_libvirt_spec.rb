require 'spec_helper'

describe 'kickstack::nova::compute::libvirt' do

  setup_required_facts
  setup_required_hiera_data('nova')

  let :pre_condition do
    'include kickstack::nova::compute'
  end

  describe 'with default params' do
    it 'should configure nova' do
      should contain_class('kickstack::nova::config')
      should contain_class('kickstack::nova::compute::libvirt')
      should contain_class('nova::compute::libvirt').with({
        :libvirt_type => 'kvm',
        :vncserver_listen => '127.0.0.1'
      })
    end
  end

end
