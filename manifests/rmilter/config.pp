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
# Title/Name format
# ------------
# 
# For convenience reasons, this resource also allows to encode the values for $section
# and $key into the resource's name (which is usally the same as its title).
#
# If the $name of the resource matches the format "<sections>.<name>", and both
# $sections and $key have not been specified, the values from the name are 
# used.
# This simplifies creating unique resources for identical settings in different 
# files.
#
# @param sections
#   An array of section names that define the hierarchical name of this key.
#   E.g. `["classifier", "bayes"] to denote the `classifier "bayes" {` section.
#
#   If arrays of values are required (including arrays of maps, i.e. multiple 
#   sections with the same name), the key must be succeeded by an bracketed index,
#   e.g.
#
#   ```
#   sections => ["statfile[0]"],
#   key      => "token",
#   value    => "BAYES_HAM",
#
#   sections => ["statifle[1]"],
#   key      => "token",
#   value    => "BAYES_SPAM",
#   ```
#
# @param key
#   The key name of the config setting. The key is expected as a single non-hierachical 
#   name without any sections/maps.
#
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
  Optional[Array[String]] $sections = undef,
  Optional[String] $key             = undef,
  $value,
  Rspamd::Ucl::ValueType $type      = 'auto',
  Optional[String] $comment         = undef,
  Enum['present', 'absent'] $ensure = 'present',
) {
  $full_file = "${rspamd::rmilter::config_path}/rmilter.local.conf"

  if (!$key and !$sections and $name =~ /\A(.+\.)?([^.]+)\z/) {
    $configsections = split($1, '\.')
    $configkey = $2
  } else {
    $configsections = pick($sections, [])
    $configkey = pick($key, $name)
  }

  $full_key = join($configsections + $configkey, '/')
  notice("full key = ${full_key}, sections = ${configsections}")
  rspamd::ucl::config { "rmilter config ${full_file} ${full_key}":
    file     => $full_file,
    sections => $configsections,
    key      => $configkey,
    value    => $value,
    type     => $type,
    comment  => $comment,
    ensure   => $ensure,
    notify   => Service['rmilter'],
  }
}

