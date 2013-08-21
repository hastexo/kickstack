#
# This roles includes everythign needed to set
# up a controller for quantum
#
# This is obviously doing way too much atm
#
#
class kickstack::network_controller {

  include kickstack::quantum::config
  include kickstack::quantum::plugin
  include kickstack::quantum::server
  include kickstack::quantum::agent::metadata
  include kickstack::quantum::agent::l3
  include kickstack::quantum::agent::dhcp
  include kickstack::quantum::agent::l2::network

}
