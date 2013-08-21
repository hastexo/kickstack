# deploys everything onto a single node
class kickstack::all_in_one {

  include kickstack::controller
  include kickstack::compute
  include kickstack::network_controller

}
