#
# kickstack cinder volume class.
#
#
class kickstack::cinder::volume(
  $backend        = hiera('cinder_backend', 'iscsi'),
  $package_ensure = hiera('package_ensure', 'present'),
) inherits kickstack {

  include kickstack::cinder::config

  include "kickstack::cinder::volume::${backend}"

  class { '::cinder::volume':
    package_ensure => $package_ensure,
  }

}
