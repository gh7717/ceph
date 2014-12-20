file { "/etc/ssh/":
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  source  => "./keys/",
  recurse => true,
  require => Package['openssh-server'],
  notify  => Service['sshd'],
}
