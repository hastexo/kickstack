#
# This is a helper define that is used to
# build out the individual database classes for
# all of the openstack components
#
# Usually data lookups happen from classes, but this
# is a lot cleaner...
#
define kickstack::db(
  $password      = hiera("${name}_db_password"),
  $user          = hiera("${name}_db_user", $name),
  $db_name       = hiera("${name}_db_name", $name),
  $host          = hiera('db_host', '127.0.0.1'),
  # TODO what should be default be?
  $allowed_hosts = hiera('db_allowed_hosts', false),
  $type          = hiera('db_type', $::kickstack::db_type)
) {

  if $type == 'mysql' {

    class { "${name}::db::mysql":
      dbname        => $db_name,
      user          => $user,
      password      => $password,
      charset       => 'utf8',
      allowed_hosts => $allowed_hosts,
    }

  } elsif $type == 'postgresql' {

    class { "${name}::db::postgresql":
      dbname   => $db_name,
      user     => $user,
      password => $password,
    }

  } else {
    fail("Unsupported database type: ${type}")
  }

  # export the password for this database
  data { "${name}_db_password":
    value => $password,
  }

}
