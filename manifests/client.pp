#
# bacic helper definition to invoke openstack
# client classes
#
define kickstack::client {

  $servicename = $name
  $classname = "::${servicename}::client"

  class { "${classname}":
  }

}
