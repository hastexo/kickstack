#
# Sets up a nova controller
#
class kickstack::nova::controller(
  $network_type      = hiera('nova_network_type', 'quantum'),
  $volume_on_compute = hiera('volume_on_compute', true),
) {

  include kickstack::nova::config
  include kickstack::nova::api
  include kickstack::nova::scheduler
  include kickstack::nova::objectstore
  include kickstack::nova::cert
  include kickstack::nova::consoleauth
  include kickstack::nova::conductor
  include kickstack::nova::quantumclient
  include kickstack::nova::vncproxy

}
