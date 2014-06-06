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

  $service_name = "${name}-logshipper"
  $upstart_file_path = "/etc/init/${name}-logshipper.conf"
  $config_file_path = "${lumberjack::config_dir}/${name}-logshipper.json"

  file { $upstart_file_path :
    ensure => $ensure,
    content => template('lumberjack/logshipper.conf.erb'),
  }

  file { $config_file_path :
    ensure => $ensure,
    content => template('lumberjack/logshipper.json.erb'),
    require => [
      File[$lumberjack::config_dir],
      File[$lumberjack::cert_path],
    ],
  }

  service { $service_name:
    ensure    => $service_ensure,
    hasstatus => false,
  }

  if $ensure == 'present' {
    File[$upstart_file_path] ~> Service[$service_name]
    File[$config_file_path] ~> Service[$service_name]
    File[$lumberjack::cert_path] ~> Service[$service_name]
  } else {
    Service[$service_name] -> File[$upstart_file_path]
    Service[$service_name] -> File[$config_file_path]
    Service[$service_name] -> File[$lumberjack::cert_path]
  }
}
