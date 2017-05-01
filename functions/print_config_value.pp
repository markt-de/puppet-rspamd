# == Function: rspamd::print_config_value()
#
# Returns a properly quoted config value
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
function rspamd::print_config_value($value, Rspamd::ValueType $type) {
  $re_number = /\A(\d+(\.\d+)?([kKmMgG]b?|s|min|d|w|y)?|0x[0-9A-F]+)\z/
  $re_boolean = /\A(true|false|on|off|yes|no)\z/
  $target_type = $type ? {
    'auto' => $value ? {
      $re_number => 'number',
      Numeric => 'number',
      $re_boolean => 'boolean',
      Boolean => 'boolean',
      default => 'string',
    },
    default => $type,
  }
  
  notice("Printing ${target_type} ${value}")
  case $target_type {
    'number': {
      case $value {
        $re_number, Numeric: {
          String($value)
        }
        default: {
          fail("Cannot convert ${value} to numeric UCL value.")
        }
      }
    }
    'boolean': {
      case $value {
        $re_boolean, Boolean: { 
          String($value)
        }
        default: {
          fail("Cannot convert ${value} to boolean UCL value.")
        }
      }
    }
    'string': {
      case $value {
        /\n/: {
          $eod = $value ? {
            /^EOD$/ => "EOD${fqdn_rand(1000000)}",
            default => 'EOD',
          }
          "<<${eod}\n${value}\n${eod}\n"
        }
        /\A[A-Za-z0-9]+\z/: {
          $value
        }
        String: {
          # let's assume the puppet string representation is good enough for rspamd.
          # Please file a bug if it isn't.
          String($value, "%p")
        }
        default: {
          # for everything else, convert to string, and then let puppet quote it
          String(String($value), "%p")
        }
      }
    }
    default: {
      fail("Invalid value type ${target_type}. This should not happen.")
    }
  }
}
