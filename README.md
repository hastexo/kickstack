# overview

This project is a prototype that is intended to replace the puppet-openstack module.

# what does it do?

This module is intended to serve as a wrapper around the other openstack core modules.

It is intended to be used with Puppet > 3.x and relies on both hiera as well as
Puppet Data Bindings.

It assists with how data is assigned in a few different ways.

1. it uses hiera, and maps data elements to a specific key from hiera's
store. This allows 3 things:

- hiera can map multiple parameter's to the same value (ie: debug, verbose, service\_tenant)
- hiera performs external lookup and does not rely on parameter passing, this means that
you can re-include classes contained in this module.

This makes it easier to have an ::all class be composed of it's ::controller and ::client classes.

2. what about the other parameters that were not explicitly passed in? I want to open a pull request :)

In general please don't. The parameters that are being forwarded through this data layer were choosen
for a few reasons:
- they are required (like password)
- they all need the same value (ie: debug, verbose)
- they are ip addresses and host names required for connections
- backend selection

All other data can be explicitly set by using Puppet Data Bindings:

ie:

nova::compute::force\_config\_drive: true

# can you explain how the design is layed out?

yes, I can and will eventually :)



# I have the following questions about data in init.pp

  # TODO does this belong in init.pp?
  # TODO why is it here, and not in init.pp
  # I am thinking that I want this here b/c it shoudl be introspectalbe,
  # why would service tenant not be the same?
  # they should both tend to be in the same tend?
