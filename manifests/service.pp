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
) {

  $manage_real = str2bool($manage)
  if $manage_real == true {
    service { 'tomcat':
      ensure  => running,
      enable  => true,
    }
  }
}
