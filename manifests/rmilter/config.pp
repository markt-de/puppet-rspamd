# Class: rspamd::rmilter::config
# ==============================
#
# Manages a single rmilter config entry
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
# Variables
# ----------
#
# * `$rspamd::rmilter::config_path`
#
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

