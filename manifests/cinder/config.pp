#
class kickstack::cinder::config(
  $db_password  = hiera('cinder_db_password'),
  $db_user      = hiera('cinder_db_user', 'cinder'),
  $db_name      = hiera('cinder_db_name', 'cinder'),
  $db_host      = hiera('db_host', '127.0.0.1'),
  $db_type      = hiera('db_type', $::kickstack::db_type),
  $rpc_type     = hiera('rpc_type', $::kickstack::rpc_type),
  $rpc_host     = hiera('rpc_host', '127.0.0.1'),
  $rpc_user     = hiera('rpc_user', 'openstack'),
  $rpc_password = hiera('rpc_password'),
  $verbose      = hiera('verbose', $::kickstack::verbose),
  $debug        = hiera('debug', $::kickstack::debug),
) inherits kickstack {

  $sql_connection_string = "${db_type}://${db_user}:${db_password}@${db_host}/${db_name}"

  case $rpc_type {
    'rabbitmq': {
      class { '::cinder':
        sql_connection      => $sql_connection_string,
        rpc_backend         => 'cinder.openstack.common.rpc.impl_kombu',
        rabbit_host         => $rpc_host,
        rabbit_userid       => $rpc_user,
        rabbit_password     => $rpc_password,
        verbose             => $verbose,
        debug               => $debug,
      }
    }
    'qpid': {
      class { '::cinder':
        sql_connection      => $sql_connection_string,
        rpc_backend         => 'cinder.openstack.common.rpc.impl_qpid',
        qpid_hostname       => $rpc_host,
        qpid_username       => $rpc_user,
        qpid_password       => $rpc_password,
        verbose             => $verbose,
        debug               => $debug,
      }
    }
    default: {
      fail("Unsupported rpc_type: ${rpc_type}")
    }
  }
}
