class lumberjack (
  $host,
  $deb_source,
  $cert_source,
  $port = 5665,
  $config_dir = '/etc/lumberjack',
  $deb_path = '/var/tmp/lumberjack.deb',
  $cert_path = '/etc/ssl/lumberjack.pub',
) {

  file { $deb_path:
    ensure => present,
    source => $deb_source,
  }

  file { $cert_path:
    ensure => present,
    source => $cert_source,
    mode   => '0400',
  }

  package { 'lumberjack':
    ensure    => latest,
    provider  => dpkg,
    source    => $deb_path,
    require   => File[$deb_path]
  }

  file { $config_dir :
    ensure => directory,
  }

}
