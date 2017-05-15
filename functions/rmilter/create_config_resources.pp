# Function: rspamd::rmilter::create_config_resources()
# ==================
#
# @summary create rspamd::rmilter::config resources from a nested hash (e.g. from hiera)
#
# Create rspamd::rmilter::config resources from a nested hash, suitable for
# conveniently loading values from hiera.
# The key-value pairs from the hash represent config keys and values
# passed to rspamd::rmilter::config for simple values, Hash values recursively
# create nested sections.
# 
# @param config_hash a hash of (non-hierarchical) key names mapped to values
# @param params      a hash of params passed to rspamd::rmilter::config (must not include :sections, :key, or :value)
# @param sections    the section names of the hierarchical key, will usually only be specified 
#   on recursive calls from within this function itself
#
# @see rspamd::rmilter::config
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
function rspamd::rmilter::create_config_resources(Hash[String, NotUndef] $config_hash, Hash $params={}, Array[String] $sections=[]) {
  $config_hash.each |$key, $value| {
    case $value {
      Hash: {
        rspamd::rmilter::create_config_resources($value, $params, $sections + $key)
      }
      Array: {
        $indexed_hash = $value.map |$index, $v| {
          { "${key}[${index}]" => $v }
        }.reduce({}) |$a,$b| { $a + $b }
        rspamd::rmilter::create_config_resources($indexed_hash, $params, $sections)
      }
      default: {
        rspamd::rmilter::config { "${params[file]}:${join($sections + $key, '.')}":
          sections => $sections,
          key      => $key,
          value    => $value,
          * => $params
        }
      }
    }
  }
}
