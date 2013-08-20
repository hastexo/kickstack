#
# I may not want to use this define b/c it does not expose
# the parameters
#
class kickstack::cinder::db inherits kickstack {

  kickstack::db { 'cinder': }

}
