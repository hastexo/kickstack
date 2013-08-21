#
# Configures iscsi backend for cinder
#
class kickstack::cinder::volume::iscsi(
  $physical_volume = hiera('physical_volume', 'cinder-volumes'),
  $volume_group    = hiera('volume_group', 'cinder-volumes'),
  $bind_address    = hiera('cinder_volume_address', '0.0.0.0')
) inherits kickstack {

  include kickstack::cinder::config

  # do we need these? should they be in their own class?
#  physical_volume { $physical_volume:
#    ensure => present
#  }
#  volume_group { $volume_group:
#    ensure           => present,
#    physical_volumes => $physical_volume,
#    require          => Physical_volume[$physical_volume]
#  }

  class { '::cinder::volume::iscsi':
    iscsi_ip_address => $bind_address,
    volume_group     => $volume_group,
#    require          => Volume_group[$volume_group],
  }
}
