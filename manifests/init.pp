# Class: kickstack
#
# The kickstack class serves as a central place to
# collect global configuration that needs to be globally available
# to your entire openstack infrastructure
#
class kickstack (
  $package_ensure       = hiera('package_ensure', 'present'),
  $name_resolution      = hiera('name_resolution', 'hosts'),
  $verbose              = hiera('verbose', false),
  $debug                = hiera('debug', false),

  # global auth information
  $auth_region          = hiera('auth_region', 'RegionOne'),
  $auth_service_tenant  = hiera('service_tenant', 'services'),

  # I am not sure if the type stuff should be here, in most cases,
  # it simply maps to a single class.
  # but is it more convenient to be here?
  # allows users to globally select all of the backends that need to be configured
  $db_type              = hiera('db_type', $::kickstack::params::db_type),
  $rpc_type             = hiera('rpc_type', $::kickstack::params::rpc_type),
  $cinder_backend       = hiera('cinder_backend', 'iscsi'),
  $glance_backend       = hiera('glance_backend', 'file'),
  $nova_compute_type    = hiera('compute_type', 'libvirt'),
  # supports quantum and nova network
  $network_type         = hiera('network_type', 'quantum'),
  $management_nic       = hiera('management_nic', 'eth2'),
) inherits kickstack::params {

  # should these be here? (probably)
  include openstack::repo
  if $name_resolution == 'hosts' {
    include kickstack::nameresolution
  }

}
