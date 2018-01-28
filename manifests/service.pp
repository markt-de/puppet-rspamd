# @api private 
# This class handles services. Avoid modifying private classes.
class rspamd::service inherits rspamd {
  if ($rspamd::service_manage) {
    service { 'rspamd':
      ensure    => 'running',
      enable    => true,
      subscribe => Class['rspamd::install'],
    }
  }
}
