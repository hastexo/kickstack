define kickstack::db {

  include pwgen

  $fact_prefix = $::kickstack::fact_prefix
  $database = $::kickstack::database

  $servicename = $name
  $username = $name

  $password      = hiera("${name}_db_password"),

  # Export facts about the database only after configuring the database
  Class["${servicename}::db::${database}"] -> Exportfact::Export<| tag == "$database" |>

  # Configure the service database (classes look like nova::db::mysql or
  # glance::db:postgresql, for example).
  # If running on mysql, set the "allowed_hosts" parameter to % so we
  # can connect to the database from anywhere.
  case "${database}" {
    "mysql": {
      class { "${servicename}::db::mysql":
            user => "$username",
            password => "$sql_password",
            charset => "utf8",
            allowed_hosts => '%',
            notify => Kickstack::Exportfact::Export["${name}_sql_connection"]
      }
    }
    default: {
      class { "${name}::db::${database}":
            password => "$sql_password"
      }
    }
  }

  # export the password for this database
  data { "${name}_db_password":
    value => $password,
  }

}
