# Class: rspamd::config
# ===========================
#
# Manages a single config entry
#
# Title/Name format
# ------------
#
# For convenience reasons, this resource allows users to encode both the values 
# for $key and $file into the resource's name (which is usally the same as its
# title).
#
# If the $name of the resource matches the format "<file>:<name>", and both $file
# and $key have not been specified, the values from the name are used.
# This simplifies creating unique resources for identical settings in different 
# files.
#
# Parameters
# ----------
# 
# * `key`
# The key name of the config setting. The key is expected as a hierachical value, 
# defining both sections/maps and entry keys, separated by dots ('.').
# E.g. the value `backend.servers` would denote the `servers` key in the `backend`
# section.
#
# * `file`
# The file to put the value in. This module keeps Rspamd's default configuration
# and makes use of its overrides. The value of this parameter must not include
# any path information or file extension.
# E.g. `bayes-classifier`
# 
# * `type`
# The type of the value, can be `auto`, `string`, `number`, `boolean`.
#
# The default, `auto`, will try to determine the type from the input value:
# Numbers and strings looking like supported number formats (e.g. "5", "5s", "10min",
# "10Gb", "0xff", etc.) will be output literally.
# Booleans and strings looking like supported boolean formats (e.g. "on", "off", 
# "yes", "no", "true", "false") will be output literally.
# Everything else will be output as a strings, unquoted if possible but quoted if
# necessary. Multi-line strings will be output as <<EOD heredocs.
#
# If you require string values that look like numbers or booleans, explicitly
# specify type => 'string'
#
# * `mode`
# Can be `merge` or `override`, and controls whether the config entry will be
# written to `local.d` or `override.d` directory.
#
# Variables
# ----------
#
# * `$rspamd::config_path`

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
define rspamd::config (
  Optional[String] $file            = undef,
  Optional[String] $key             = undef,
  $value,
  Rspamd::ValueType $type           = 'auto',
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

  rspamd::ucl_config { "rspamd config ${full_file} ${configkey}":
    file    => $full_file,
    key     => $configkey,
    value   => $value,
    type    => $ype,
    comment => $comment,
    ensure  => $ensure,
    notify  => Service['rspamd'],
  }
}

