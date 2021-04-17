# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include homeserver::bind
class homeserver::bind {
  include firewalld
  # install bind packages
  package { ['bind', 'bind-utils']:
    ensure => present,
  }

  # /etc/named.conf and /var/named/home.root.db
  -> file {'/etc/named.conf':
    ensure  => present,
    content => file('homeserver/named.conf'),
    owner   => 'root',
    group   => 'named',
    mode    => '0640',
  }
  -> file {'/var/named/home.root.db':
    ensure  => present,
    content => file('homeserver/home.root.db'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
  # enable and start named service
  -> service { 'named':
    ensure => running,
    enable => true,
  }
  # open port 53 both tcp and udp
  -> firewalld_port { 'Open port 53/tcp in the public zone':
    ensure   => present,
    zone     => 'public',
    port     => 53,
    protocol => 'tcp',
  }
  -> firewalld_port { 'Open port 53/udp in the public zone':
    ensure    => present,
    zone      => 'public',
    port      => 53,
    protocol => 'udp',
  }
}
