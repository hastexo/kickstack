Puppet::Type.newtype(:data) do

  desc <<-EOT

  This type is simply used by a node to store data in Puppetdb
  so that another node can retrieve it later.

  EOT

  newparam(:key, :namevar => true) do
    desc 'key for data entry'
  end

  newparam(:value) do
    desc 'value that can be looked up by key'
  end

end
