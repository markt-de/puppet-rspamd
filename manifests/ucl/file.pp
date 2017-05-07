# Class: rspamd::ucl::file
# ===========================
#
# Manages a single UCL (Universal Configuration Language) config file
#
# This class is only for internal use, use rspam::config or rspam::rmilter::config
# instead.
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
define rspamd::ucl::file (
  Stdlib::Absolutepath $file        = $title,
  Optional[String] $comment         = undef,
  Enum['present', 'absent'] $ensure = 'present',
) {
  concat { $file:
    owner => 'root',
    group => 'root',
    mode  => '0644',
    warn  => !$comment,
    order => 'alpha',
  }

  if ($comment) {
    concat::fragment { "rspamd ${file} UCL config 01 file warning comment":
      target => $file,
      content => join(suffix(prefix(split($comment, '\n'), "# "), "\n")),
    }
  }
}

