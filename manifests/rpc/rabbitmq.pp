#
class kickstack::rpc::rabbitmq(
  $password       = hiera('rpc_password'),
  $user           = hiera('rpc_user', 'openstack'),
  $virtual_host   = hiera('rabbitmq_virtual_host', '/'),
  $management_nic = hiera('management_nic',$::kickstack::management_nic),
) inherits kickstack {

  class { 'nova::rabbitmq':
    userid       => $user,
    password     => $password,
    virtual_host => $virtual_host,
  }

  data { 'rpc_host':
    value => get_ip_from_nic($management_nic),
  }

  data { 'rpc_password':
    value => $password,
  }

}
