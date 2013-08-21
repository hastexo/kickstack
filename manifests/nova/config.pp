#
class kickstack::nova::config(
  $db_password        = hiera('nova_db_password'),
  $db_user            = hiera('nova_db_user', 'nova'),
  $db_name            = hiera('nova_db_name', 'nova'),
  $db_host            = hiera('db_host', '127.0.0.1'),
  $db_type            = hiera('db_type', $::kickstack::db_type),
  $glance_api_servers = hiera('glance_api_servers', ['127.0.0.1:9292']),
  $rpc_host           = hiera('rpc_host', '127.0.0.1'),
  $rpc_user           = hiera('rpc_user', 'openstack'),
  $rpc_password       = hiera('rpc_password'),
) inherits kickstack {

  $sql_connection_string = "${db_type}://${db_user}:${db_password}@${db_host}/${db_name}"

  # NOTE I tried to reimplement this using class inheritance
  # and by having kickstack::nova::config::{rabbitmq,qpid} classes
  # but this did not work b/c classes do not work with class
  # inheritance. The real solution here is to break out the rpc
  # config from the nova base class
  case $::kickstack::rpc_type {

    'rabbitmq': {
      class { '::nova':
        ensure_package      => $::kickstack::package_ensure,
        sql_connection      => $sql_connection_string,
        rpc_backend         => 'nova.openstack.common.rpc.impl_kombu',
        rabbit_host         => $rpc_host,
        rabbit_password     => $rpc_password,
        rabbit_userid       => $rpc_user,
        auth_strategy       => 'keystone',
        verbose             => $::kickstack::verbose,
        debug               => $::kickstack::debug,
        glance_api_servers  => $glance_api_servers,
      }
    }
    'qpid': {
      class { '::nova':
        ensure_package     => $::kickstack::package_ensure,
        sql_connection     => $sql_connection_string,
        rpc_backend        => 'nova.openstack.common.rpc.impl_qpid',
        qpid_hostname      => $rpc_host,
        qpid_password      => $rpc_password,
        qpid_username      => $rpc_user,
        auth_strategy      => 'keystone',
        verbose            => $::kickstack::verbose,
        debug              => $::kickstack::debug,
        glance_api_servers => $glance_api_servers,
      }
    }
    default: {
      fail("Unsupported rpc_type: ${$::kickstack::rpc_type}")
    }
  }
}
