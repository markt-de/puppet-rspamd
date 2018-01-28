# @api private 
# This class handles packages. Avoid modifying private classes.
class rspamd::install inherits rspamd {
  if ($rspamd::package_manage) {
    package { 'rspamd':
      ensure => 'present',
      name   => $rspamd::package_name,
    }
  }
}
