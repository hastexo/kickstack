#
class kickstack::keystone::all {

  include kickstack::keystone::api
  include kickstack::keystone::endpoints

}
