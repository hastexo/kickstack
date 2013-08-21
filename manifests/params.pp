#
# OS specific parameters
#
class kickstack::params {

  case $::osfamily {
    'RedHat': {
      $rpc_type = 'qpid'
      $db_type  = 'mysql'
    }
    'Debian': {
      $rpc_type = 'rabbitmq'
      $db_type  = 'mysql'
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily}")
    }
  }

}
