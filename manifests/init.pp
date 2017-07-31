# Class: rspamd
# ===========================
#
# Main entry point for the rspamd module
#
# @summary this class allows you to install and configure the Rspamd system and its services
# 
# @example
#   include rspamd
#
# @param packages_install  whether to install the rspamd package
# @param service_manage    whether to manage the rspamd service
# @param repo_baseurl	   use a different repo url instead of rspamd.com upstream repo
# @param manage_package_repo whether to add the upstream package repo to your system (includes {rspamd::repo})
# @param config_path       the path containing the rspamd config directory
# @param purge_unmanaged   whether local.d/override.d config files not managed by this module should be purged
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
class rspamd (
  Boolean $packages_install        = true,
  Boolean $service_manage          = true,

  Optional[String] $repo_baseurl   = undef,
  Boolean $manage_package_repo     = true,

  String $config_path              = '/etc/rspamd',
  Boolean $purge_unmanaged         = true,
) {

  if ($packages_install) {
    package { 'rspamd':
      ensure => 'present',
      name   => 'rspamd',
    }

  }

  if ($purge_unmanaged) {
    file { 'purge unmanaged rspamd local.d files':
      ensure  => 'directory',
      path    => "${config_path}/local.d",
      recurse => true,
      purge   => true,
    }
    file { 'purge unmanaged rspamd override.d files':
      ensure  => 'directory',
      path    => "${config_path}/override.d",
      recurse => true,
      purge   => true,
    }
  }


  if ($service_manage) {
    service { 'rspamd':
      ensure  => 'running',
      enable  => true,
      require => Package['rspamd'],
    }
  }


  if($manage_package_repo) {
    class { 'rspamd::repo':
      baseurl => $repo_baseurl,
    }
  }
}
