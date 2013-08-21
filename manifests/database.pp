#
#
class kickstack::database(
  $db_type = hiera('db_type', $::kickstack::db_type),
) inherits kickstack {
  include "kickstack::database::${db_type}"
}
