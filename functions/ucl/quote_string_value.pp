# @summary quotes a string as a valid UCL string
# @note this is internal API and should never be required by users
#
# @return the quoted string suitable for inclusion in a ucl config file
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
function rspamd::ucl::quote_string_value(String $value) {
  # this uses puppet's double-quoted string representation, and assumes
  # it to be good enough for rspamd. Please file a bug if it isn't.

  if ($value =~ /(?:'|\$|\p{Cntrl}|\\)/) {
    # this will already be double-quoted
    String($value, "%p")
  } else {
    # otherwise enforce double-quotes by prefixing with a '
    $prefixed = String("'$value", "%#p")
    if ($prefixed =~ /\A"'(.*)"\z/) {
      "\"${1}\""
    } else {
      fail("Expected quoted string to start with \"', got ${prefixed} instead.")
    }
  }
}
