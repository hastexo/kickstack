module Puppet::Parser::Functions
  newfunction(:get_ip_from_nic, :type => :rvalue, :doc => <<-EOS
    Returns the ip address assigned to the provided nic. It raises
    and exception if it cannot find the ip address. It locates the
    address by taking the nic, and using it to lookup the value of
    its related fact.

    A provided nic of 'eth1' would return the value of the fact ipaddress_eth1.
    EOS
  ) do |args|

    raise(Puppet::ParseError, "get_ip_from_nic(): Wrong number of arguments " +
      "given (#{args.size} instead of 1)") if args.size != 1

    fact_name = "::ipaddress_#{args[0]}"
    ip = self.lookupvar(fact_name)
    raise(Puppet::ParseError, "Could not find ip address for fact: #{fact_name}") unless ip
    ip

  end
end
