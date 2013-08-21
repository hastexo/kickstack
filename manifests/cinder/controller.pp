#
class kickstack::cinder::controller {
  include kickstack::cinder::config
  include kickstack::cinder::api
  include kickstack::cinder::scheduler
}

