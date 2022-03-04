class homeserver::nfs{
  class { '::nfs':
    server_enabled => true
  }
  nfs::server::export{ '/home':
    ensure  => 'mounted',
    clients => '192.168.86.0/24(rw,insecure,async,no_root_squash) localhost(rw)'
  }
}
