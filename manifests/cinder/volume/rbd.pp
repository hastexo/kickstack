#
class kickstack::cinder::volume::rbd(
  # TODO what should be default be?
  $rbd_pool        = hiera('rbd_pool'),
  $rbd_user        = hiera('rbd_user', 'cinder'),
  $rbd_secret_uuid = hiera('rbd_secret_uuid'),
) inherits kickstack {

  include kickstack::cinder::config

  class { '::cinder::volume::rbd':
    rbd_pool        => $rbd_pool,
    rbd_user        => $rbd_user,
    rbd_secret_uuid => $rbd_secret_uuid
  }
}
