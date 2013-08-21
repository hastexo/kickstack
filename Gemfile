source :rubygems

group :development, :test do
  gem 'puppetlabs_spec_helper', :require => false
  gem 'hiera-puppet-helper'
  gem 'puppet-lint'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
