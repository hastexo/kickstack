# kickstack::keystone::endpoints
#
# Configures endpoints
#
class kickstack::keystone::endpoints(
  $enable_cinder   = hiera('enable_cinder', true),
  $enable_glance   = hiera('enable_glance', true),
  $enable_keystone = hiera('enable_keystone', true),
  $enable_nova     = hiera('enable_nova', true),
  $enable_quantum  = hiera('enable_quantum', true),
  $enable_swift    = hiera('enable_swift', false),
) {

  if $enable_cinder {
    include kickstack::cinder::endpoint
  }
  if $enable_glance {
    include kickstack::glance::endpoint
  }
  if $enable_keystone {
    include kickstack::keystone::endpoint
  }
  if $enable_nova {
    include kickstack::nova::endpoint
  }
  if $enable_swift {
    include kickstack::swift::endpoint
  }
  if $enable_quantum {
    include kickstack::quantum::endpoint
  }

}
