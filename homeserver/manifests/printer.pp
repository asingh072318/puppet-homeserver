# @summary A short summary of the purpose of this class
#
# Driver Installation & cups setup for Canon E477 on CentOS
#
# @example
#   include homeserver::printer
class homeserver::printer(
  $printer_name = 'mx490',
  $printer_hash = lookup('homeserver::printer::printer_hash'),
  ) {
  # install prerequisite packages
  $packages = ['cups','cups-devel', 'rpm-build', 'autoconf', 'libtool', 'automake', 'gcc-c++', 'glib2-devel', 'libusbx-devel', 'libxml2-devel']
  package { $packages:
    ensure => installed,
  }

  -> service { 'cups':
    ensure => running,
    enable => true,
  }

  # download E477 source code
  -> archive { '/tmp/cnijfilter2-source-5.40-1.tar.gz':
    ensure => present,
    source => 'https://gdlp01.c-wss.com/gds/3/0100008393/01/cnijfilter2-source-5.40-1.tar.gz',
    user   => 'root',
    group  => 'root',
  }

  # build rpm
  -> exec { 'Build E477 Driver from source':
    command   => '/usr/bin/rpmbuild -tb /tmp/cnijfilter2-source-5.40-1.tar.gz',
    logoutput => true,
    provider  => 'shell',
    unless    => 'rpm -qa | grep cnijfilter2-5.40-1.x86_64 2>/dev/null',
  }

  # install
  -> package { 'Install using RPM':
    ensure   => 'installed',
    provider => 'rpm',
    source   => '/root/rpmbuild/RPMS/x86_64/cnijfilter2-5.40-1.x86_64.rpm',
  }

  # add printer and accept,enable
  -> exec {'Add printer.home.root':
    command   => "lpadmin -p home_printer -v socket://printer.home.root -P ${printer_hash[$printer_name]}",
    logoutput => true,
    provider  => 'shell',
    unless    => 'lpstat -v home_printer',
  }
  -> exec { 'accept printer':
    command   => '/sbin/cupsaccept home_printer',
    logoutput => true,
    provider  => 'shell',
  }
  -> exec { 'enable printer':
    command   => '/sbin/cupsenable home_printer',
    logoutput => true,
    provider  => 'shell',
  }
  # remove driver archive
  -> file { '/tmp/cnijfilter2-source-5.40-1.tar.gz':
    ensure => 'absent',
  }

}
