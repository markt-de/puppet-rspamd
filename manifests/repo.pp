class rspamd::repo (
  $baseurl = undef,
) {
  case $::osfamily {
    'Debian': {
      class { 'rspamd::repo::apt_stable': }
    }

    default: {
      fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports managing repos for osfamily Debian")
    }
  }
}

