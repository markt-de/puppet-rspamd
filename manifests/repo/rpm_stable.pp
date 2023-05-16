# Class: rspamd::repo::rpm_stable
# =============
#
# @summary includes the rspamd.com/rpm-stable rpm repo
# @note PRIVATE CLASS: do not use directly
# @see rspamd::repo
# 
class rspamd::repo::rpm_stable inherits rspamd::repo {
  # Here we have tried to replicate the instructions on the rspamd site:
  #
  # https://rspamd.com/downloads.html
  #

  if $::operatingsystem in ['CentOS', 'Fedora'] {
    $_osname = downcase($::operatingsystem)
    $default_baseurl = "http://rspamd.com/rpm-stable/${_osname}-${::operatingsystemmajrelease}/x86_64/"
  } else {
    fail("Unsupported managed repository for osfamily: ${::osfamily}, operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports managing repos for operatingsystem Fedora and CentOS")
  }

  $_baseurl = pick($rspamd::repo_baseurl, $default_baseurl)

  yumrepo { 'rspamd':
    baseurl       => $_baseurl,
    descr         => 'Rspamd stable repository',
    enabled       => '1',
    gpgcheck      => '1',
    gpgkey        => 'http://rspamd.com/rpm/gpg.key',
    repo_gpgcheck => '1',
  }

  exec { 'import rspamd gpg key':
    path      => '/bin:/usr/bin:/sbin:/usr/sbin',
    command   => 'rpm --import https://rspamd.com/rpm-stable/gpg.key',
    unless    => 'rpm -q gpg-pubkey-`curl -s https://rspamd.com/rpm-stable/gpg.key | gpg --throw-keyids | cut --characters=12-19 | tr [A-Z] [a-z] | head -n 1`',
    logoutput => 'on_failure',
  }

  Yumrepo['rspamd'] -> Exec['import rspamd gpg key'] -> Package<|tag == 'rspamd'|>

}
