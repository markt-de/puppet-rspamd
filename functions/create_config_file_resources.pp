# == Function: rspamd::create_config_file_resources()
#
# Create rspamd::config resources from a nested hash, suitable for
# conveniently loading values from hiera.
# The first level of keys is the config files to be written to, the
# values being the hierarchical values that will be passed to 
# the rspamd::create_config_resources function
#
# === Authors
#
# Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
# === Copyright
#
# Copyright 2017 Bernhard Frauendienst, unless otherwise noted.
#
# === License
#
# 2-clause BSD license
#
function rspamd::create_config_file_resources(Hash[String, Hash] $configfile_hash, Hash $params = {}) {
  $configfile_hash.each |$key, $value| {
    $file_params = {
      file => $key
    } + $params
    rspamd::create_config_resources($value, $file_params)
  }
}
