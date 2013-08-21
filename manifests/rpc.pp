#
#
class kickstack::rpc(
  $db_type = hiera('rpc_type', $::kickstack::rpc_type),
) inherits kickstack {
  include "kickstack::rpc::${rpc_type}"
}
