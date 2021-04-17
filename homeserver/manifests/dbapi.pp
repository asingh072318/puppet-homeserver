# @summary A short summary of the purpose of this class
#
# dbapi fetch and setup
#
# @example
#   include homeserver::dbapi
# 
class homeserver::dbapi {
  # handle prereq packages
  $packages = [ 'gcc', 'openssl-devel', 'bzip2-devel', 'libffi-devel']
  package { $packages:
    ensure => installed,
  }
  # create directory /home/scripts
  -> file { '/home/scripts':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }
  # git clone https://github.com/g4mewarrior/flask_restplus.git
  -> vcsrepo { '/home/scripts/dbapi':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/g4mewarrior/flask_restplus.git',
  }
  # setup python3, pip3 and venv
  -> class { 'python':
    version              => '3.6.8',
    pip                  => 'present',
    dev                  => 'present',
    python_pyvenvs       => {"/home/scripts/dbapi/apienv" => {"version" => "system"}},
  }
  -> exec {'pip install requirements':
    path      => '/usr/local/bin/:/bin:/usr/sbin',
    command   => '/home/scripts/dbapi/apienv/bin/pip install -r /home/scripts/dbapi/requirements.txt',
    logoutput => true,
    provider  => 'shell',
  }
}
