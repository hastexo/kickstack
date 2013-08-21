#
class kickstack::cinder::scheduler(
  $package_ensure = hiera('package_ensure', 'present')
) inherits kickstack {

  include kickstack::cinder::config

  class { '::cinder::scheduler':
    package_ensure   => $package_ensure,
    scheduler_driver => 'cinder.scheduler.simple.SimpleScheduler',
  }
}
