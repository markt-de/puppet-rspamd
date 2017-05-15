# rspamd::ucl::config
# ===========================
#
# @summary manages a single UCL (Universal Configuration Language) config entry
#
# @note This class is only for internal use, use rspam::config or rspam::rmilter::config
#   instead.
#
# @param file     the file to put the entry in
# @param key      the entry's key
# @param sections the entry's sections as an array
# @param value    the entry's value
# @param type     the type to enforce (or `auto` for auto-detection)
# @param comment  an optional comment to be printed above the entry
# @param ensure   whether the entry should be `present` or `absent`
#
# @see rspamd::config
# @see rspamd::rmilter::config
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
define rspamd::ucl::config (
  Stdlib::Absolutepath $file,
  String $key,
  Array[String] $sections           = [],
  $value,
  Rspamd::Ucl::ValueType $type      = 'auto',
  Optional[String] $comment         = undef,
  Enum['present', 'absent'] $ensure = 'present',
) {
  ensure_resource('rspamd::ucl::file', $file)

  $depth = length($sections)
  if ($depth > 0) {
    Integer[1,$depth].each |$i| {
      $section = join($sections[0,$i], '/')
      $indent = sprintf("%${($i-1)*2}s", '')

      # strip the [x] array qualifier
      $section_name = $sections[$i-1] ? {
        /^(.*)\[\d+\]$/ => $1,
        default         => $sections[$i-1]
      }
      ensure_resource('concat::fragment', "rspamd ${file} UCL config /${section} 03 section start", {
        target => $file,
        content => "${indent}${section_name} {\n",
      })
      ensure_resource('concat::fragment', "rspamd ${file} UCL config /${section}/~ section end", { # ~ sorts last
        target => $file,
        content => "${indent}}\n",
      })
    }
  }

  # now for the value itself
  $indent = sprintf("%${$depth*2}s", '')
  $section_key = join($sections + $key, '/')
  $entry_key = $key ? {
    /^(.*)\[\d+\]$/ => $1,
    default         => $key
  }

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

