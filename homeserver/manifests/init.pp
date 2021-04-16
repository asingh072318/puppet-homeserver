# @summary A short summary of the purpose of this class
#
# Class to manage my homeserver.
#
# @example
#   include homeserver
class homeserver {
  # install puppet_vim
  include homeserver::vim

  #install and configure postgresql
  include homeserver::postgresql
}
