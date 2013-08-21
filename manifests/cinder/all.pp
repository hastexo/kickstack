#
# Installs a cinder controller and volume on the same node.
#
class kickstack::cinder::all {
  include ::kickstack::cinder::controller
  include ::kickstack::cinder::volume
}
