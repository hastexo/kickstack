#
# class that installs a mysql server
#
class kickstack::database::mysql(
  # TODO  is there any advantage to defining this in hiera?
  $root_password  = hiera('database_root_password'),
  $bind_address   = hiera('database_bind_address', '0.0.0.0'),
  $management_nic = hiera('management_nic', $::kickstack::management_nic)
) inherits kickstack{

  class { 'mysql::server':
    config_hash => {
      'root_password' => $root_password,
      'bind_address'  => $bind_address,
    }
  }

  include mysql::server::account_security

  file { '/etc/mysql/conf.d/skip-name-resolve.cnf':
    source => 'puppet:///modules/kickstack/mysql/skip-name-resolve.cnf',
  }

  data { 'db_host':
    value => get_ip_from_nic($management_nic),
  }

}
