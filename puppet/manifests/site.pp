# -*- mode: ruby -*-
# vi: set ft=ruby :
# vi :set number :

# add ceph user to sudo groups
group { 'ceph':
  ensure    => 'present',
}
user { 'ceph':
  ensure    => 'present',
  password  => '$6$zDeCCAC8$nhbPg2.YKEYvBTaMq7ph7Q03rGv2nPlVU4fXzF0dRTMxAhHFZfPIUTK.vTvAj6AJiMcr7mzh3KS92M94hU/nj.',
  home      => '/home/ceph',
  shell     => '/bin/bash',
  groups => ['sudo', 'ceph'],
  require => Group['ceph'],
}
exec { "apt-get update":
    command => "/usr/bin/apt-get update",
    onlyif => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'",
}
package { 'vim':
  ensure  => 'installed',
  require => Exec['apt-get update'],
}
file { '/home/ceph/.ssh':
  ensure => directory,
  require => File['/home/ceph'],
}
file {'/home/ceph':
  ensure => directory,
  require => User['ceph'],
}
host {'node-1':
  ip => $::node_ip1,
}
host {'node-2':
  ip => $::node_ip2,
}
host {'node-3':
  ip => $::node_ip3,
}

# configure  only ssh key access!!!!
file {'/home/vagrant/.ssh/id_rsa':
  ensure => file,
  source => '/vagrant/puppet/modules/profiles/id_rsa',
  owner  => 'ceph',
  group  => 'ceph',
  require => File['/home/ceph/.ssh'],
}
file { '/home/vagrant/.ssh/id_rsa.pub':
  ensure => file,
  source => '/vagrant/puppet/modules/profiles/id_rsa.pub',
  owner  => 'ceph',
  group  => 'ceph',
}
sshkey { 'node-1':
  ensure       => present,
  host_aliases => $::node_ip1,
  key          => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDYzkF7Z5YHqzI01Jc/Ek6Alve9MsGNT4rMO98AYFWAiMMAygiJJ74H/DEOedrZOlBOzlnXCLJJ6YfFXcGTPgTQ8DQ8s4wyHHlF+uY35yrQg04v05B2x4zuoFKCwGsh5g2uVsGRZkdv6WWp02g09yuzsw8KUqv5OvsIliWOxJQYIudrZnZWgr6379Nuogc+/th6Ku38GV42EKFZp14Xvry+8UrlzBDI/CIbCGjD3VgR+1poDc1KdFbSuOJ93xDoX0xXVODRg9FzXM7l07pcSknNn+IHFMi3W4HnKS3HgggpOYBqksh7TEvmLQBTXj9QROzjjsA4ptqt7FBYPHo9w+pj',
  type         => 'ssh-rsa',
}
sshkey { 'node-2':
 ensure       => present,
 host_aliases => $::node_ip2,
 key          => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDYzkF7Z5YHqzI01Jc/Ek6Alve9MsGNT4rMO98AYFWAiMMAygiJJ74H/DEOedrZOlBOzlnXCLJJ6YfFXcGTPgTQ8DQ8s4wyHHlF+uY35yrQg04v05B2x4zuoFKCwGsh5g2uVsGRZkdv6WWp02g09yuzsw8KUqv5OvsIliWOxJQYIudrZnZWgr6379Nuogc+/th6Ku38GV42EKFZp14Xvry+8UrlzBDI/CIbCGjD3VgR+1poDc1KdFbSuOJ93xDoX0xXVODRg9FzXM7l07pcSknNn+IHFMi3W4HnKS3HgggpOYBqksh7TEvmLQBTXj9QROzjjsA4ptqt7FBYPHo9w+pj',
 type         => 'ssh-rsa',
}
#ssh_authorized_key { 'gh771@laptop':
# user => 'ceph',
# type => 'ssh-rsa',
# key          => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDYzkF7Z5YHqzI01Jc/Ek6Alve9MsGNT4rMO98AYFWAiMMAygiJJ74H/DEOedrZOlBOzlnXCLJJ6YfFXcGTPgTQ8DQ8s4wyHHlF+uY35yrQg04v05B2x4zuoFKCwGsh5g2uVsGRZkdv6WWp02g09yuzsw8KUqv5OvsIliWOxJQYIudrZnZWgr6379Nuogc+/th6Ku38GV42EKFZp14Xvry+8UrlzBDI/CIbCGjD3VgR+1poDc1KdFbSuOJ93xDoX0xXVODRg9FzXM7l07pcSknNn+IHFMi3W4HnKS3HgggpOYBqksh7TEvmLQBTXj9QROzjjsA4ptqt7FBYPHo9w+pj',
#}
