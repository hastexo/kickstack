#
# class used to configured databases
#
class kickstack::database::databases(
  $enable_cinder   = hiera('enable_cinder', true),
  $enable_glance   = hiera('enable_glance', true),
  $enable_keystone = hiera('enable_keystone', true),
  $enable_nova     = hiera('enable_nova', true),
  $enable_swift    = hiera('enable_swift', false),
  $enable_quantum  = hiera('enable_quantum', true),
) {

  if $enable_cinder {
    include kickstack::cinder::db
  }
  if $enable_glance {
    include kickstack::glance::db
  }
  if $enable_keystone {
    include kickstack::keystone::db
  }
  if $enable_nova {
    include kickstack::nova::db
  }
  if $enable_swift {
    include kickstack::swift::db
  }
  if $enable_quantum {
    include kickstack::quantum::db
  }

}
