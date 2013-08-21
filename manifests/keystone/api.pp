class kickstack::keystone::api inherits kickstack {
  include pwgen  

  $admin_token = pick(getvar("${fact_prefix}keystone_admin_token"),pwgen())
  $admin_password = pick(getvar("${fact_prefix}keystone_admin_password"),pwgen())
  $admin_tenant = $::kickstack::keystone_admin_tenant
  $sql_conn = getvar("${fact_prefix}keystone_sql_connection")
  $management_nic   = hiera('management_nic', $::kickstack::management_nic),

  class { '::keystone':
    package_ensure => $::kickstack::package_ensure,
    verbose        => $kickstack::verbose,
    debug          => $kickstack::debug,
    catalog_type   => 'sql',
    admin_token    => $admin_token,
    sql_connection => $sql_conn,
  }

  # Installs the service user endpoint.
  class { '::keystone::endpoint':
    public_address   => "${hostname}${keystone_public_suffix}",
    admin_address    => "${hostname}${keystone_admin_suffix}",
    internal_address => $hostname,
    region           => $keystone_region,
    require      => Class['::keystone']
  }

  }

  # Adds the admin credential to keystone.
  class { '::keystone::roles::admin':
    email        => $kickstack::keystone_admin_email,
    password     => $admin_password,
    admin_tenant => $admin_tenant,
    service_tenant => $kickstack::keystone_service_tenant,
    require      => Class['::keystone::endpoint']
  }

  file { '/root/openstackrc':
    owner => root,
    group => root,
    mode => '0640',
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
