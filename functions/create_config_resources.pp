# == Function: rspamd::create_config_resources()
#
# Create rspamd::config resources from a nested hash, suitable for
# conveniently loading values from hiera.
# The key-value pairs from the hash represent config keys and values
# passed to rspamd::config for simple values, Hash values recursively
# create nested sections.
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
function rspamd::create_config_resources(Hash[String, NotUndef] $config_hash, Hash $params, Optional[String] $section=undef) {
  $config_hash.each |$key, $value| {
    $qualified_key = $section ? {
      Undef => $key,
      default => "${section}.${key}"
    }
    case $value {
      Hash: {
        rspamd::create_config_resources($value, $params, $qualified_key)
      }
      default: {
        rspamd::config { "${params[file]}:${qualified_key}":
          key   => $qualified_key,
          value => $value,
          * => $params
        }
      }
    }
  }
}
