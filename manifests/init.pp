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
# @param package_manage    whether to install the rspamd package
# @param service_manage    whether to manage the rspamd service
# @param repo_baseurl	   use a different repo url instead of rspamd.com upstream repo
# @param manage_package_repo whether to add the upstream package repo to your system (includes {rspamd::repo})
# @param config_path       the path containing the rspamd config directory
# @param purge_unmanaged   whether local.d/override.d config files not managed by this module should be purged
# @param configs           configurations, ensured using rspamd::create_config_file_resources
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
class rspamd (
  String $config_path,
  Boolean $manage_package_repo,
  Boolean $package_manage,
  String $package_name,
  Boolean $purge_unmanaged,
  Optional[String] $repo_baseurl,
  Boolean $service_manage,
  Hash $configs = {},
) {
  contain rspamd::repo
  contain rspamd::install
  contain rspamd::configuration
  contain rspamd::service

  rspamd::create_config_file_resources($configs)

  Class['::rspamd::repo']
  -> Class['::rspamd::install']
  -> Class['::rspamd::configuration']
  ~> Class['::rspamd::service']
}
