# Class: rspamd::rmilter
# ===========================
#
# Installs and configures rmilter
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
class rspamd::rmilter (
  Boolean $packages_install        = true,
  Boolean $service_manage          = true,

  String $config_path              = "/etc",
  Boolean $purge_unmanaged         = true,

  Boolean $disable_legacy_features = true,
) {

  if ($packages_install) {
    package { 'rmilter':
      ensure => 'present',
      name   => 'rmilter',
    }
  }

  if ($purge_unmanaged) {
    file { "purge unmanaged rmilter.conf.d files":
      path => "${config_path}/rmilter.conf.d",
      ensure => 'directory',
      recurse => 'true',
      purge => 'true',
    }

    rspamd::ucl::file { "${config_path}/rmilter.local.conf": }
  }

  if ($service_manage) {
    service { 'rmilter':
      ensure  => 'running',
      enable  => true,
      require => Package['rmilter'],
    }
  }

  if ($disable_legacy_features) {
    rspamd::rmilter::config {
      default: comment => "Disable legacy feature. Use Rspamd module instead.";
      'limits.enable': value => false;
      'greylisting.enable': value => false;
      'dkim.enable': value => false;
    }
  }
}
