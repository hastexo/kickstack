#
# installs a fully functional glance node
#
class kickstack::glance::all(
  $backend = hiera('glance_backend', 'file')
) {

  include kickstack::glance::api
  include kickstack::glance::config
  include "kickstack::glance::backend::${backend}"
  include kickstack::glance::registry

}
