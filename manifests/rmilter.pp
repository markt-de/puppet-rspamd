# Class: rspamd::rmilter
# ===========================
#
# This class installs and manages the rmilter service that can be used to
# connect your MTA to the Rspamd system.
#
# @summary this class allows you to install and configure the rmilter service
# 
# @example
#   include rspamd::rmilter
#
# @param packages_install  whether to install the rmilter package
# @param service_manage    whether to manage the rmilter service
# @param config_path       the path containing the rmilter config files
# @param purge_unmanaged   whether rmilter.conf.d config files not managed by this module should be purged
# @param disable_legacy_features
#   Disable rmilter's legacy features that have been re-implemented in rspamd and are no longer maintained 
#   in rmilter. Future versions of rmilter will disable those by default, until then, this class does that.
#
#   These features are: limits, greylisting, dkim
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
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

    rspamd::ucl::file { "${config_path}/rmilter.conf.local": }
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
