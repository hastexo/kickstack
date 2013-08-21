#
class kickstack::controller {

  include kickstack::glance::all
  include kickstack::keystone::all
  include kickstack::cinder::controller
  include kickstack::nova::controller
  include kickstack::horizon
  include kickstack::network_controller

  include kickstack::database
  include kickstack::database::databases
  include kickstack::rpc
  include kickstack::memcached

}
