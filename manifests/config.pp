# Class: rspamd::config
# ===========================
#
# Manages a single config entry
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
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
define rspamd::config (
  String $file,
  $value,
  Rspamd::ValueType $type           = 'auto',
  Enum['merge', 'override'] $mode   = 'merge',
  Optional[String] $comment         = undef,
  Enum['present', 'absent'] $ensure = 'present',
) {
  $folder = $mode ? {
    'merge' => 'local.d',
    'override' => 'override.d',
  }
  $full_file = "${rspamd::config_path}/${folder}/${file}.conf"

  ensure_resource('concat', $full_file, {
    owner => 'root',
    group => 'root',
    mode  => '0644',
    warn  => true,
    order => 'alpha',
    notify => Service['rspamd'],
  })

  $sections = split($name, '\.')
  $depth = length($sections)-1
  if ($depth > 0) {
    Integer[1,$depth].each |$i| {
      $section = join($sections[0,$i], '/')
      $indent = sprintf("%${($i-1)*2}s", '')

      ensure_resource('concat::fragment', "rspamd ${file} config /${section} 03 section start", {
        target => $full_file,
        content => "${indent}${sections[$i-1]} {\n",
      })
      ensure_resource('concat::fragment', "rspamd ${file} config /${section}/~ section end", { # ~ sorts last
        target => $full_file,
        content => "${indent}}\n",
      })
    }
  }

  # now for the value itself
  $indent = sprintf("%${$depth*2}s", '')
  $section_key = join($sections, '/')
  $key = $sections[-1]

  if ($comment) {
    concat::fragment { "rspamd ${file} config /${section_key} 01 comment":
      target => $full_file,
      content => join(suffix(prefix(split($comment, '\n'), "${indent}# "), "\n")),
    }
  }

  $printed_value = rspamd::print_config_value($value, $type)
  $semicolon = $printed_value ? {
    /\A<</ => '',
    default => ";\n"
  }
    
  concat::fragment { "rspamd ${file} config /${section_key} 02":
    target => $full_file,
    content => "${indent}${key} = ${printed_value}${semicolon}",
  }
}

