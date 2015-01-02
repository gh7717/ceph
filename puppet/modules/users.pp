# -*- mode: ruby -*-
# vi: set ft=ruby :
# vi :set number :
class users{
    user {'ceph':
      ensure => 'present',
      managehome => true,
      password  => '$6$zDeCCAC8$nhbPg2.YKEYvBTaMq7ph7Q03rGv2nPlVU4fXzF0dRTMxAhHFZfPIUTK.vTvAj6AJiMcr7mzh3KS92M94hU/nj.',
      groups => ['sudo', 'ceph'],
    }
    exec {'sudoers.d':
          command => "/bin/echo 'ceph ALL = (root) NOPASSWD:ALL' > /etc/sudoers.d/ceph",
          require => User['ceph'],
    }
}
