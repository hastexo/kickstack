#
class kickstack::rpc::qpid(
  $password       = hiera('rpc_password'),
  $user           = hiera('rpc_user', 'openstack'),
  $realm          = hiera('qpid_realm', 'OPENSTACK'),
  $management_nic = hiera('management_nic',$::kickstack::management_nic)
) inherits kickstack{

  class { 'nova::qpid':
    user     => $user,
    password => $password,
    realm    => $realm,
  }

  data { 'rpc_host':
    value => get_ip_from_nic($management_nic),
  }

  data { 'rpc_password':
    value => $password,
  }
}
