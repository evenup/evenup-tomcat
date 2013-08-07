# == Class: tomcat::service
#
# This class manages the tomcat service.  It should not be called directly
#
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
#
# === Copyright
#
# Copyright 2013 EvenUp.
#
class tomcat::service (
  $manage     = true,
  $monitoring = '',
) {

  if $manage {
    service { 'tomcat':
      ensure  => running,
      enable  => true,
    }
  }

  # Monitoring
  case $monitoring {
    'sensu':  {
      class { 'tomcat::monitoring::sensu': }
    }
    default: {}
  }

}
