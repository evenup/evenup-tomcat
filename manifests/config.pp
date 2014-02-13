# == Class: tomcat::config
#
# This class configures tomcat.  It should not be called directly.
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
class tomcat::config(
  $install_dir,
  $admin_pass,
  $java_opts,
  $env_vars,
  $header_fragment,
  $footer_fragment
) {

  # are we overriding the concat fragments?
  $real_header_fragment = $tomcat::config::header_fragment ? {
    false   => 'tomcat/server.xml.header',
    default => $tomcat::config::header_fragment,
  }
  $real_footer_fragment = $tomcat::config::footer_fragment ? {
    false   => 'tomcat/server.xml.footer',
    default => $tomcat::config::footer_fragment,
  }

  File {
    ensure  => 'file',
    owner   => 'tomcat',
    group   => 'tomcat',
    mode    => '0444',
    notify  => Class['tomcat::service'],
  }

  file { "${install_dir}/tomcat/conf/catalina.policy":
    source  => 'puppet:///modules/tomcat/catalina.policy',
  }

  file { "${install_dir}/tomcat/conf/context.xml":
    source  => 'puppet:///modules/tomcat/context.xml',
  }

  file { "${install_dir}/tomcat/conf/logging.properties":
    source  => 'puppet:///modules/tomcat/logging.properties',
  }

  file { "${install_dir}/tomcat/conf/tomcat-users.xml":
    mode    => '0440',
    content => template('tomcat/tomcat-users.xml.erb'),
  }

  file { "${install_dir}/tomcat/bin/setenv.sh":
    mode    => '0544',
    content => template('tomcat/setenv.sh.erb'),
  }

  file { "${install_dir}/tomcat/bin/web.xml":
    source  => 'puppet:///modules/tomcat/web.xml',
  }

  file { "${install_dir}/tomcat/conf/Catalina":
    ensure  => directory,
    mode    => '0555',
    purge   => true,
    recurse => true,
    force   => true,
  }

  file { "${install_dir}/tomcat/conf/Catalina/localhost":
    ensure  => directory,
    mode    => '0555',
    purge   => true,
    recurse => true,
  }

  concat{
    "${install_dir}/tomcat/conf/server.xml":
      owner   => tomcat,
      group   => tomcat,
      mode    => 0444,
      notify  => Class['tomcat::service'],
  }

  concat::fragment{ 'server_xml_header':
    target  => "${install_dir}/tomcat/conf/server.xml",
    content => template($tomcat::config::real_header_fragment),
    order   => 01,
  }

  concat::fragment{ 'server_xml_footer':
    target  => "${install_dir}/tomcat/conf/server.xml",
    content => template($tomcat::config::real_footer_fragment),
    order   => 99,
  }

  # Logrotate for tomcat logs
  logrotate::file { 'tomcat':
    ensure  => 'present',
    log     => "${tomcat::log_dir}/catalina.out",
    options => ['missingok', 'notifempty', 'copytruncate', 'sharedscripts', 'daily', 'compress'],
  }

}
