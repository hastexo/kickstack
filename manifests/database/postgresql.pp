#
class kickstack::database::postgresql(
  $root_password  = hiera('database_root_password'),
  $bind_address   = hiera('database_bind_address', '*')
  $management_nic = hiera('management_nic', $::kickstack::management_nic)
) inherits kickstack{

  class { 'postgresql::server':
    config => {
      'ip_mask_deny_postgres_user' => '0.0.0.0/32',
      'ip_mask_allow_all_users'    => '0.0.0.0/0',
      'listen_addresses'           => $bind_address,
      'postgres_password'          => $root_password,
    }
  }

  data { 'db_host':
    value => get_ip_from_nic($management_nic),
  }
}
