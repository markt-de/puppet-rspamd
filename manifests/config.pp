# rspamd::config
# ===========================
#
# @summary this type manages a single config entry
# 
# Rspamd uses its own UCL (Unified Configuration Language) format. This format
# basically allows to define a hierarchy of configuration objects.
#
# Since in puppet, we want to map each single config entry as its own resource,
# the hierarchy has been "flattened" to hierarchical keys.
#
# A key/value pair `foo = bar` nested in a `section` object, would look like 
# this in UCL:
#
# ```json
# section {
#   foo = bar
# }
# ```
#
# To reference this key in a rspam::config variable, you would use the 
# notation `section.foo`.
#
# UCL also allows to define arrays, by specifying the same key multiple times.
# To map this feature to a flattened key name, we use a numerical index in
# brackets.
# For example, this UCL snippet
#
# ```json
# statfile {
#   token = "BAYES_HAM"
# }
# statfile {
#   token = "BAYES_SPAM"
# }
# ```
#
# would be mapped to
#
# ```
# statfile[0].token = "BAYES_HAM"
# statfile[1].token = "BAYES_SPAM"
# ```
# 
# Title/Name format
# ------------
# 
# This module manages keeps Rspamd's default configuration untouched, and manages
# only local override config files. This matches the procedure recommended by the
# Rspamd authors.
#
# To specify which file a config entry should got to, you can use the `file` 
# parameter.
#
# For convenience reasons, however, this resource also allows to encode both the 
# values for $key and $file into the resource's name (which is usally the same as 
# its title).
#
# If the $name of the resource matches the format "<file>:<name>", and both $file
# and $key have not been specified, the values from the name are used.
# This simplifies creating unique resources for identical settings in different 
# files.
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
#
# @param file
#   The file to put the value in. This module keeps Rspamd's default configuration
#   and makes use of its overrides. The value of this parameter must not include
#   any path information or file extension.
#   E.g. `bayes-classifier`
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
# @param mode
#   Can be `merge` or `override`, and controls whether the config entry will be
#   written to `local.d` or `override.d` directory.
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
define rspamd::config (
  Optional[String] $file            = undef,
  Optional[String] $key             = undef,
  $value,
  Rspamd::Ucl::ValueType $type      = 'auto',
  Enum['merge', 'override'] $mode   = 'merge',
  Optional[String] $comment         = undef,
  Enum['present', 'absent'] $ensure = 'present',
) {
  if (!$key and !$file and $name =~ /^([^:]+):(.*)$/) {
    $configfile = $1
    $configkey = $2
  } else {
    $configfile = $file
    $configkey = pick($key, $name)
  }
  unless $configfile {
    fail("Could not detect file name in resource title, must specify one explicitly")
  }
 
  $folder = $mode ? {
    'merge' => 'local.d',
    'override' => 'override.d',
  }
  $full_file = "${rspamd::config_path}/${folder}/${configfile}.conf"

  rspamd::ucl::config { "rspamd config ${full_file} ${configkey}":
    file    => $full_file,
    key     => $configkey,
    value   => $value,
    type    => $type,
    comment => $comment,
    ensure  => $ensure,
    notify  => Service['rspamd'],
  }
}

