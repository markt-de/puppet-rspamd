# == Type: Rspamd::ValueType
#
# Simple enum for possible types of config values.
#
# Can be used in rspamd::config definitions to force a certain type.
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
type Rspamd::Ucl::ValueType = Enum['auto', 'string', 'number', 'boolean']
