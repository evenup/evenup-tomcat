# == Class: tomcat::monitoring::sensu
#
# This class configures sensu monitoring for tomcat.  It should not be called
# directly
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
class tomcat::monitoring::sensu {
  # Checking httpd is running
  sensu::check { 'tomcat-running':
    handlers    => 'default',
    command     => '/etc/sensu/plugins/check-procs.rb -p -Dcatalina.base=/usr/share/tomcat -C 1',
    custom      => { 'refresh' => 1800 },
  }

  sensu::subscription { 'tomcat': }
}
