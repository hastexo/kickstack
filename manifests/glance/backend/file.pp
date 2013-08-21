#
class kickstack::glance::backend::file {
  include kickstack::glance::api
  include ::glance::backend::file
}
