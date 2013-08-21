require 'spec_helper'

describe 'kickstack::cinder::volume::iscsi' do

  setup_required_facts
  setup_required_hiera_data('cinder')

  describe 'with defaults' do

    it 'should configure the cinder iscsi backend' do
      should contain_class('kickstack::cinder::config')
      should contain_physical_volume('cinder-volumes').with_ensure('present')
      should contain_volume_group('cinder-volumes').with({
        :ensure           => 'present',
        :physical_volumes => 'cinder-volumes',
        :require          => 'Physical_volume[cinder-volumes]',
      })
      should contain_class('cinder::volume::iscsi').with({
        :iscsi_ip_address => '0.0.0.0',
        :volume_group     => 'cinder-volumes',
        :require          => 'Volume_group[cinder-volumes]',
      })
    end
  end

  describe 'when overriding parameters' do
    let :hiera_data do
      req_params.merge({
        :physical_volume       => 'pv',
        :volume_group          => 'vg',
        :cinder_volume_address => '127.0.0.1',
      })
    end
    it 'should configure iscsi volumes' do
      should contain_physical_volume('pv').with_ensure('present')
      should contain_volume_group('vg').with({
        :ensure           => 'present',
        :physical_volumes => 'pv',
        :require          => 'Physical_volume[pv]',
      })
      should contain_class('cinder::volume::iscsi').with({
        :iscsi_ip_address => '127.0.0.1',
        :volume_group     => 'vg',
        :require          => 'Volume_group[vg]',
      })
    end
  end

end
