#
# bacic helper definition to invoke openstack
# client classes
#
define kickstack::client {

  include "::${name}::client"

}
