# rspamd::rmilter::config
# ===========================
#
# @summary this type manages a single config entry
# 
# Rmilter uses the same UCL (Unified Configuration Language) format as rspamd.
# See rspamd::config for details.
#
# However, because rmilter's config is much simpler, and this module does not to
# intend its legacy features that have been migrated to rspamd, it only supports
# the single rmilter.local.conf config file.
#
# @param key
#   The key name of the config setting. The key is expected as a hierachical value, 
#   defining both sections/maps and entry keys, separated by dots ('.').
#   E.g. the value `backend.servers` would denote the `servers` key in the `backend`
#   section.
#   
#   If arrays of values are required (including arrays of maps, i.e. multiple 
#   sections with the same name), the key must be succeeded by an bracketed index,
#   e.g.
#
#   ```
#   statfile[0].token = "BAYES_HAM"
#   statifle[1].token = "BAYES_SPAM"
#   ```
# @param value
#   the value of this config entry. See `type` for allowed types.
#
# @param type
#   The type of the value, can be `auto`, `string`, `number`, `boolean`.
#
#   The default, `auto`, will try to determine the type from the input value:
#   Numbers and strings looking like supported number formats (e.g. "5", "5s", "10min",
#   "10Gb", "0xff", etc.) will be output literally.
#   Booleans and strings looking like supported boolean formats (e.g. "on", "off", 
#   "yes", "no", "true", "false") will be output literally.
#   Everything else will be output as a strings, unquoted if possible but quoted if
#   necessary. Multi-line strings will be output as <<EOD heredocs.
#   
#   If you require string values that look like numbers or booleans, explicitly
#   specify type => 'string'
#
# @param comment
#   an optional comment that will be written to the config file above the entry
#
# @param ensure
#   whether this entry should be `present` or `absent`. Usually not needed at all,
#   because the config file will be fully managed by puppet and re-created each time.
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
define rspamd::rmilter::config (
  String $key                       = $title,
  $value,
  Rspamd::Ucl::ValueType $type      = 'auto',
  Optional[String] $comment         = undef,
  Enum['present', 'absent'] $ensure = 'present',
) {
  $full_file = "${rspamd::rmilter::config_path}/rmilter.local.conf"

  rspamd::ucl::config { "rmilter config ${full_file} ${key}":
    file    => $full_file,
    key     => $key,
    value   => $value,
    type    => $ype,
    comment => $comment,
    ensure  => $ensure,
    notify  => Service['rmilter'],
  }
}

