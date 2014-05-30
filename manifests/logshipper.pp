define lumberjack::logshipper (
  $log_files,
  $fields = { },
  $ensure = 'present',
){

  if $ensure == 'absent' {
    $service_ensure = 'stopped'
  }
  else {
    $service_ensure = 'running'
  }

  $upstart_file_path = "/etc/init/${name}-logshipper.conf"
  $config_file_path = "${lumberjack::config_dir}/${name}-logshipper.json"

  file { $upstart_file_path :
    ensure => $ensure,
    content => template('lumberjack/logshipper.conf.erb'),
    notify  => Service["${name}-logshipper"]
  }

  file { $config_file_path :
    ensure => $ensure,
    content => template('lumberjack/logshipper.json.erb'),
    require => [
      File[$lumberjack::config_dir],
      File[$lumberjack::cert_path]
    ],
    notify  => Service["${name}-logshipper"]
  }

  service { "${name}-logshipper":
    ensure    => $service_ensure,
    require   => [File[$upstart_file_path], File[$config_file_path]],
    subscribe => [File[$lumberjack::cert_path]],
    hasstatus => false
  }

}
