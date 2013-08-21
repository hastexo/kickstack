#
class kickstack::glance::backend::swift(
  $swift_store_user         = hiera('swift_store_user', 'swift'),
  $swift_store_key          = hiera('swfit_store_key'),
  $swift_store_auth_address = hiera('swift_store_auth_address'),
) {
  class { '::glance::backend::swift':
    swift_store_user                    => $swift_store_user,
    swift_store_key                     => $swift_store_key,
    swift_store_auth_address            => $swift_store_auth_address,
    swift_store_create_container_on_put => true,
  }
}
