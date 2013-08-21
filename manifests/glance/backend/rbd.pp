#
class kickstack::glance::backend::rbd(
  $rbd_store_user = hiera('glance_rbd_user'),
  $rbd_store_pool = hiera('glance_rbd_pool'),
) {
  class { '::glance::backend::rbd':
    rbd_store_user => $rbd_store_user,
    rbd_store_pool => $rbd_store_pool,
  }
}
