define lumberjack::logshipper (
  $log_files,
  $fields = { },
){

  $upstart_file_path = "/etc/init/${name}-logshipper.conf"
  $config_file_path = "${lumberjack::config_dir}/${name}-logshipper.json"

  file { $upstart_file_path :
    content => template('lumberjack/logshipper.conf.erb'),
    notify  => Service["${name}-logshipper"]
  }

  file { $config_file_path :
    content => template('lumberjack/logshipper.json.erb'),
    require => [
      File[$lumberjack::config_dir],
      File[$lumberjack::cert_path]
    ],
    notify  => Service["${name}-logshipper"]
  }

  service { "${name}-logshipper":
    ensure    => running,
    require   => [File[$upstart_file_path], File[$config_file_path]],
    subscribe => [File[$lumberjack::cert_path]],
    hasstatus => false
  }

}
