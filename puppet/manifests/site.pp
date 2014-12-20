# -*- mode: ruby -*-
# vi: set ft=ruby :
# vi :set number :

# add ceph user to sudo groups

user { 'ceph':
  ensure    => 'present',
  password  => '$6$zDeCCAC8$nhbPg2.YKEYvBTaMq7ph7Q03rGv2nPlVU4fXzF0dRTMxAhHFZfPIUTK.vTvAj6AJiMcr7mzh3KS92M94hU/nj.',
#  gid       => '1003',
  home      => '/home/ceph',
  shell     => '/bin/bash',
#  uid       => '1001',
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

file {'/home/ceph/.ssh/id_rsa':
  ensure => file,
  source => '/vagrant/puppet/modules/profiles/id_rsa',
  owner  => 'ceph',
  group  => 'ceph',
  require => File['/home/ceph/.ssh'],
}
file { '/home/ceph/.ssh/id_rsa.pub':
  ensure => file,
  source => '/vagrant/puppet/modules/profiles/id_rsa.pub',
  owner  => 'ceph',
  group  => 'ceph',
}
sshkey { 'node-1':
  ensure       => present,
  host_aliases => $::node_ip1,
  key  => 'AAAB3NzaC1yc2EAAAABIwAAAQEAyBShq4Acme0WgNdEp4wbwfoRPDzOBH6gb/UlvIx3jCdEW+yMXYb2mHr8Y1GplMWNWpgZBizrapiGsDJ/2l6NAm3LTRACG3+Jcf7jNW3VNy0Yb+3PeAQ8hKrzY9VvkXIbXQy/aKLsMD1bhJP+yyY6g0YkkWkMQvarUxca2su2Jo4JWzWc91IsAyIUtiwEE+qf81oS1JjKFT5rZLKPhD9sXoTlNDikf/m2Qvc91jS0I3MPH94eLIVoiC6J0o+MLd+TSfWinMUQUZV00JFE3MyOsZ0u6/mpjFAVhh2U2wk5oVKq0DYxD6kjAi2xTHVNuwhizRFrLP6lpVcDlhmwEtD0Cw',
 type         => 'ssh-rsa',
}
sshkey { 'node-2':
 ensure       => present,
 host_aliases => $::node_ip2,
                 key  => 'AAAB3NzaC1yc2EAAAABIwAAAQEAyBShq4Acme0WgNdEp4wbwfoRPDzOBH6gb/UlvIx3jCdEW+yMXYb2mHr8Y1GplMWNWpgZBizrapiGsDJ/2l6NAm3LTRACG3+Jcf7jNW3VNy0Yb+3PeAQ8hKrzY9VvkXIbXQy/aKLsMD1bhJP+yyY6g0YkkWkMQvarUxca2su2Jo4JWzWc91IsAyIUtiwEE+qf81oS1JjKFT5rZLKPhD9sXoTlNDikf/m2Qvc91jS0I3MPH94eLIVoiC6J0o+MLd+TSfWinMUQUZV00JFE3MyOsZ0u6/mpjFAVhh2U2wk5oVKq0DYxD6kjAi2xTHVNuwhizRFrLP6lpVcDlhmwEtD0Cw',
 type         => 'ssh-rsa',
}
