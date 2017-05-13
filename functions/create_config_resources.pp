# Function: rspamd::create_config_resources()
# ==================
#
# @summary create rspamd::config resources from a nested hash (e.g. from hiera)
#
# Create rspamd::config resources from a nested hash, suitable for
# conveniently loading values from hiera.
# The key-value pairs from the hash represent config keys and values
# passed to rspamd::config for simple values, Hash values recursively
# create nested sections.
# 
# @param config_hash a hash of (non-hierarchical) key names mapped to values
# @param params      a hash of params passed to rspamd::config (must not include :key or :value)
# @param section     the section name will be prefixed to the key to form a hierarchy, will usually
#   only be specified on recursive calls from within this function itself
#
# @see rspamd::create_config_file_resources
# @see rspamd::config
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
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
      Array: {
        $indexed_hash = $value.map |$index, $v| {
          { "${key}[${index}]" => $v }
        }.reduce({}) |$a,$b| { $a + $b }
        rspamd::create_config_resources($indexed_hash, $params, $section)
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
