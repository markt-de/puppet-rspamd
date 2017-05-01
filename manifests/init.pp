# Class: rspamd
# ===========================
#
# Full description of class rspamd here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'rspamd':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
# Copyright
# ---------
#
# Copyright 2017 Bernhard Frauendienst, unless otherwise noted.
#
class rspamd (
  Boolean $packages_install        = true,
  Boolean $service_manage          = true,

  Boolean $rmilter_install         = true,

  Optional[String] $repo_baseurl   = undef,
  Boolean $manage_package_repo     = true,

  String $config_path              = "/etc/rspamd",
  Boolean $purge_unmanaged         = true,
) {

  if ($packages_install) {
    package { 'rspamd':
      ensure => 'present',
      name   => 'rspamd',
    }

    if ($rmilter_install) {
      package { 'rmilter':
        ensure => 'present',
        name   => 'rmilter',
      }
    }
  }

  if ($purge_unmanaged) {
    file { "purge unmanaged rspamd local.d files":
      path => "${config_path}/local.d",
      ensure => 'directory',
      recurse => 'true',
      purge => 'true',
    }
    file { "purge unmanaged rspamd override.d files":
      path => "${config_path}/override.d",
      ensure => 'directory',
      recurse => 'true',
      purge => 'true',
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
