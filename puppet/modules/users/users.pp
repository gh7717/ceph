class users {
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

}
