#
class kickstack::glance::config(
  $package_ensure = hiera('package_ensure', $::kickstack::package_ensure)
) inherits kickstack {
  class { '::glance':
    package_ensure => $::kickstack::package_ensure,
  }
}
