# Class: rspamd::ucl::config
# ===========================
#
# Manages a single UCL (Universal Configuration Language) config entry
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
define rspamd::ucl::config (
  Stdlib::Absolutepath $file,
  String $key,
  $value,
  Rspamd::Ucl::ValueType $type      = 'auto',
  Optional[String] $comment         = undef,
  Enum['present', 'absent'] $ensure = 'present',
) {
  ensure_resource('rspamd::ucl::file', $file)

  $sections = split($key, '\.')
  $depth = length($sections)-1
  if ($depth > 0) {
    Integer[1,$depth].each |$i| {
      $section = join($sections[0,$i], '/')
      $indent = sprintf("%${($i-1)*2}s", '')

      ensure_resource('concat::fragment', "rspamd ${file} UCL config /${section} 03 section start", {
        target => $file,
        content => "${indent}${sections[$i-1]} {\n",
      })
      ensure_resource('concat::fragment', "rspamd ${file} UCL config /${section}/~ section end", { # ~ sorts last
        target => $file,
        content => "${indent}}\n",
      })
    }
  }

  # now for the value itself
  $indent = sprintf("%${$depth*2}s", '')
  $section_key = join($sections, '/')
  $entry_key = $sections[-1]

  if ($comment) {
    concat::fragment { "rspamd ${file} UCL config /${section_key} 01 comment":
      target => $file,
      content => join(suffix(prefix(split($comment, '\n'), "${indent}# "), "\n")),
    }
  }

  $printed_value = rspamd::ucl::print_config_value($value, $type)
  $semicolon = $printed_value ? {
    /\A<</ => '',
    default => ";\n"
  }
    
  concat::fragment { "rspamd ${file} UCL config /${section_key} 02":
    target => $file,
    content => "${indent}${entry_key} = ${printed_value}${semicolon}",
  }
}

