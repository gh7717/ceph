
#vim: set ft=ruby :
#-*- mode:ruby; tab-width:8; c-basic-offset:2; indent-tabs-mode:t -*- 
#vim: ts=8 sw=2 smarttab
#vim: numset
class users{
  group {'ceph':
    ensure => 'present',
  }
  user {'ceph':
    ensure => 'present',
    managehome => true,
    password  => '$6$zDeCCAC8$nhbPg2.YKEYvBTaMq7ph7Q03rGv2nPlVU4fXzF0dRTMxAhHFZfPIUTK.vTvAj6AJiMcr7mzh3KS92M94hU/nj.',
    groups => ['sudo', 'ceph'],
    shell => '/bin/bash',
    require => Group['ceph'],
  }
  exec {'sudoers.d':
    command => "/bin/echo 'ceph ALL = (root) NOPASSWD:ALL' > /etc/sudoers.d/ceph",
    require => User['ceph'],
  }
  file {'/home/ceph/.ssh':
   ensure => 'directory',
   owner => 'ceph',
   group => 'ceph',
   mode => '0700',
   require => User['ceph'],
  }
}
class app{
  package {'vim':
    ensure => 'installed',
  }
  package {'ceph-deploy':
    ensure => 'installed',
    require => Exec['ceph.list'], 
  }
 package {'ntp':
    ensure => 'installed',
 }
 package {'wget':
    ensure => 'installed',
 }
 exec {'app-keys':
    command => '/usr/bin/wget -q -O- "https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc" | sudo apt-key add -',
    require => Package['wget'],

 }
 exec {'ceph.list':
    command => '/bin/echo deb http://ceph.com/debian-giant/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list',
    require => Exec['app-keys'],
 }
}

class ssh{
  $ssh_config = '/home/vagrant/.ssh/config'
  $private_key = '/vagrant/puppet/modules/profiles/id_rsa'
  $public_key  = '/vagrant/puppet/modules/profiles/id_rsa.pub'

  file {'/home/vagrant/.ssh/id_rsa':
     ensure => file,
     source => $private_key,
     owner  => 'vagrant',
     group  => 'vagrant',
   }
   # the code bellow doesn't work what I want.
   $nodes = ['node-1','node-2', 'node-3']
   sshkey { $nodes:
     ensure       => present,
#     host_aliases => $::node_ip1,
     key          => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDYzkF7Z5YHqzI01Jc/Ek6Alve9MsGNT4rMO98AYFWAiMMAygiJJ74H/DEOedrZOlBOzlnXCLJJ6YfFXcGTPgTQ8DQ8s4wyHHlF+uY35yrQg04v05B2x4zuoFKCwGsh5g2uVsGRZkdv6WWp02g09yuzsw8KUqv5OvsIliWOxJQYIudrZnZWgr6379Nuogc+/th6Ku38GV42EKFZp14Xvry+8UrlzBDI/CIbCGjD3VgR+1poDc1KdFbSuOJ93xDoX0xXVODRg9FzXM7l07pcSknNn+IHFMi3W4HnKS3HgggpOYBqksh7TEvmLQBTXj9QROzjjsA4ptqt7FBYPHo9w+pj',
     type         => 'ssh-rsa',
     target => '/home/vagrant/.ssh/known_hosts',
   }
   file {'/home/vagrant/.ssh/known_hosts':
     owner  => 'vagrant',
     group  => 'vagrant',
     subscribe => Sshkey[$nodes],
   }
   ssh_authorized_key {'ceph_key':
     ensure          => present,
     name            => 'gh7717@laptop',
     user            => 'vagrant',
     type            => 'ssh-rsa',
     key             => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDv+6Sv0XWv0ajMeT5f4VIjJxe8jazxUCxeFMlH6ys+RgUfWsPn5aEJLF9VoZjzMAmL+w9QLurpsR4n9OYV2xsFr74ABPTyAyvc3zrrXOzy5EJsn4tjC0AmTmn3LfgIQW+Uon4guk1N6hqAEyJfkhPdVlN7tiez3Ql12MTtmbxRBYNgv8QAH/vbl3KnGXk8/9WFzQLrgdsQFfXymGGfbgXqOAYMgKe24nVtf3nPWbiSuvZpOcwjxSxGbUU2Q/23Bq7ATwTQFdTp14BCE5ZsNbsaZonxx24yu1sHuKw8+XUGYfCgVso5VsBEyycpsN1F814b7OJr2ayihXHdVnpOzYul',
   }
  if !defined(File[$ssh_config]) {
    file { $ssh_config :
      mode    => '0600',
      owner =>  'vagrant',
      group =>  'vagrant',
      content => "Host *\n  StrictHostKeyChecking no\n  UserKnownHostsFile=/dev/null\n",
    }
  }
}
 
class network{
  host {'node-1':
          ip => $::node_ip1,
  }
  host {'node-2':
          ip => $::node_ip2,
  }
  host {'node-3':
          ip => $::node_ip3,
  }
}
# the code bellow has to work with only one node
class ceph{
  exec {'ceph-deploy-cluster':
    command => '/usr/bin/ceph-deploy new node-1 node-2 node-3',
    cwd => '/home/vagrant/',
    require => Class['app']
  }
  exec {'ceph-deploy-install':
    command => '/usr/bin/ceph-deploy install node-1 node-2 node-3', 
    require => Exec['ceph-deploy-cluster'],
    timeout => 600,
  }
  exec {'ceph-deploy-gatherkeys':
    command => '/usr/bin/ceph-deploy gatherkeys node-1 node-2 node-3',
    require => Exec['ceph-deploy-cluster'],
  }
  exec {'public_network':
    command => '/bin/echo "public network = 192.168.33.0/24" >> ceph.conf ',
    require => Exec['ceph-deploy-cluster'],
  }
  exec {'ceph-deploy-monitor-install':
    command => '/usr/bin/ceph-deploy mon create-initial',
    require => Exec['public_network'],
  }
 exec {'chmod_keyring':
   command => '/bin/chmod +r /etc/ceph/ceph.client.admin.keyring',
   subscribe => Exec['ceph-deploy-monitor-install'],
 }
 exec {'ceph-deploy-zap-disk':
   command => '/usr/bin/ceph-deploy disk zap node-1:sdb node-1:sdc node-2:sdb node-2:sdc node-3:sdb node-3:sdc',
   require => Exec['ceph-deploy-install'],
 }
 exec {'ceph-deploy-create-osd':
   command => '/usr/bin/ceph-deploy osd create node-1:sdb node-1:sdc node-2:sdb node-2:sdc node-3:sdb node-3:sdc',
   require => Exec['ceph-deploy-zap-disk'],
 }

}


node 'node-1' {
#  include users
  include app
  include ssh
  include network
}

node 'node-2' {
#  include users
  include app
  include ssh
  include network
}

node 'node-3' {
#  include users
  include app
  include ssh
  include network
  include ceph
}
