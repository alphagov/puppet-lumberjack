# puppet-lumberjack

Puppet module for installing and managing lumberjack

```puppet
lumberjack::logshipper { "collector-logs-for-${title}":
    log_files => [ "${app_path}/current/log/collector.log.json" ],
    ensure => $ensure
}
```

# setting up for testing

```
bundle install
```

#running tests

```
bundle exec rake spec 
```
