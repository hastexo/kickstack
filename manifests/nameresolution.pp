#
# Class used to setup basic name resolution in /etc/hosts
# using exported resources.
#
class kickstack::nameresolution() inherits kickstack {

  @@host { $::hostname:
    ip      => get_ip_from_nic($::kickstack::management_nic),
    comment => 'Managed by Puppet',
    tag     => 'hostname',
  }
  Host <<| tag == 'hostname' |>> {  }
}

