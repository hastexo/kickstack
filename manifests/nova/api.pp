#
class kickstack::nova::api(
  $quantum_secret   = hiera('metadata_shared_secret'),
  $management_nic   = hiera('management_nic', $::kickstack::management_nic)
) inherits kickstack {

  include kickstack::nova::config
  include pwgen

  # Grab the Keystone admin password from a kickstack fact and configure
  # Keystone accordingly. If no fact has been set, generate a password.
  $admin_password = pick(getvar("${fact_prefix}nova_keystone_password"),pwgen())
  $auth_host = getvar("${fact_prefix}keystone_internal_address")

  # Stupid hack: Grizzly packages in Ubuntu Cloud Archive
  # require python-eventlet > 0.9, but the python-nova
  # package in UCA does not reflect this
  package { 'python-eventlet':
    ensure => latest
  }

  class { '::nova::api':
    enabled           => true,
    auth_strategy     => 'keystone',
    auth_host         => $auth_host,
    admin_tenant_name => $kickstack::keystone_service_tenant,
    admin_user        => 'nova',
    admin_password    => $admin_password,
    enabled_apis      => 'ec2,osapi_compute,metadata',
    quantum_metadata_proxy_shared_secret => $quantum_secret
  }

  kickstack::endpoint { 'nova':
    service_password => $admin_password,
    require           => Class['::nova::api']
  }

  data { 'nova_metadata_ip':
    value => get_ip_from_nic($management_nic),
  }
  data { 'quantum_metadata_shared_secret':
    value => $quantum_secret,
  }

}
