# @summary A short summary of the purpose of this class
#
# A description of what this class does
# 1. install postgresql server
# 2. create superuser testuser
# 3. create database testuser and owner testuser
# 4. create table users public_id,username,password,admin,default_db,created_on
# @example
#   include homeserver::postgresql
class homeserver::postgresql {
  # create postgresql cluster with postgres user and no password
  class { 'postgresql::server':
  }

  # create role testuser with password defined in hiera, make user superuser
  -> postgresql::server::role { 'testuser':
    password_hash => postgresql::postgresql_password('testuser', 'testdbpasstest'),
    superuser     => true, 
  }

  # create db testuser with owner testuser
  -> postgresql::server::database { 'testuser':
    owner => 'testuser',
  }

  # create rule for testuser
  -> postgresql::server::pg_hba_rule{ 'custom rule for testuser':
    type => 'local',
    user => 'testuser',
    database => 'testuser',
    auth_method => 'md5',
    order => 0,
  }
}
