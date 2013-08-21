#
# models a reasonable deployment of a compute host.
# I am not happy with how complicated this is.
#
# I am considering dropping support for nova-networks
#
#
class kickstack::compute(
  $volume_on_compute = hiera('volume_on_compute', true),
  $network_type      = hiera('network_type', $::kickstack::network_type),
) inherits kickstack {

  include kickstack::nova::config
  include kickstack::nova::compute

  if $network_type == 'quantum' {
    # should this not be in the nova::compute class
    include kickstack::quantum::config
    include kickstack::nova::quantumclient
    include kickstack::quantum::agent::l2::compute
  } else {
    fail("Unsupported network type ${network_type}")
  }
  if $volume_on_compute {
    include kickstack::cinder::volume
    # TODO - don't have this here...
    # set in nova::api
    if ! defined(Nova_config['DEFAULT/volume_api_class']) {
      nova_config { 'DEFAULT/volume_api_class': value => 'nova.volume.cinder.API' }
    }
  }
}
