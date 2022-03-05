# @summary A short summary of the purpose of this class
#
# Class to manage my homeserver.
#
# @example
#   include homeserver
class homeserver(
  $packages      = lookup('homeserver::dbapi::packages')
  ) {
  # install puppet_vim
  # include homeserver::vim

  # install and configure postgresql
  # include homeserver::postgresql

  # install and configure bind dns server
  # include homeserver::bind

  # clone and deploy dbapi
  # include homeserver::dbapi

  # install and setup printer driver
  # class {'homeserver::printer':
    # printer_name => 'mx490'
  # }
  # include homeserver::nfs
  class {'nvm':
    user         => '7A13eW1',
    install_node => '14.18.1',
  }
}
