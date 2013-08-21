#
class kickstack::keystone::api(
  $db_password      = hiera('keystone_db_password'),
  $db_user          = hiera('keystone_db_user', 'keystone'),
  $db_name          = hiera('keystone_db_name', 'keystone'),
  $db_host          = hiera('db_host', '127.0.0.1'),
  $db_type          = hiera('db_type', $::kickstack::db_type),
  $admin_token      = hiera('admin_token'),
  $admin_password   = hiera('admin_password'),
  $admin_email      = hiera('admin_email', 'root@localhost'),
  $admin_tenant     = hiera('admin_tenant', 'admin'),
  $service_tenant   = hiera('service_tenant', $::kickstack::auth_service_tenant),
  $package_ensure   = hiera('package_ensure', $::kickstack::package_ensure),
  $verbose          = hiera('verbose', $::kickstack::verbose),
  $debug            = hiera('verbose', $::kickstack::debug),
  $management_nic   = hiera('management_nic', $::kickstack::management_nic),
) inherits kickstack {

  $sql_connection_string = "${db_type}://${db_user}:${db_password}@${db_host}/${db_name}"

  class { '::keystone':
    package_ensure => $package_ensure,
    verbose        => $verbose,
    debug          => $debug,
    catalog_type   => 'sql',
    admin_token    => $admin_token,
    # TODO need to build a real value here
    sql_connection => $sql_connection_string,
  }

  class { '::keystone::roles::admin':
    email          => $admin_email,
    password       => $admin_password,
    admin_tenant   => $admin_tenant,
    service_tenant => $service_tenant,
  }

  file { '/root/openstackrc':
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('kickstack/openstackrc.erb'),
    require => Class['::keystone::roles::admin']
  }

  data { 'keystone_admin_password':
    value => $admin_password,
  }

  data { 'keystone_admin_token':
    value => $admin_token,
  }

  data { 'auth_internal_address':
    value => get_ip_from_nic($::kickstack::management_nic),
  }

}
