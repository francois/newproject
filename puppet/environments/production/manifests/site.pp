schedule{'once a day':
  range  => '0-23',
  period => 'daily',
  repeat => 1,
}

# Run apt-get update and upgrade before installing any package
   exec{'/usr/bin/apt-get -qq update':      schedule => 'once a day'}
-> exec{'/usr/bin/apt-get -qq upgrade -y':  schedule => 'once a day', timeout => 0}
-> Package <| |>

package{[
  'build-essential',
  'byobu',
  'git',
  'htop',
  'libpq-dev',
  'libreadline-dev',
  'postgresql',
  'ruby',
  'ruby-dev',
  'sudo',
  'vim-nox',
  'wget',
  'zlib1g-dev',
  'zsh',
]:
  ensure => latest,
}

package{[
  'bundler',
]:
  ensure   => latest,
  provider => 'gem',
  require  => Package['ruby'],
}

file{'/home/ubuntu':
  ensure  => directory,
  mode    => '0755',
  owner   => 'ubuntu',
  group   => 'ubuntu',
  require => User['ubuntu'],
}

file{'/home/ubuntu/.config':
  ensure  => directory,
  owner   => 'ubuntu',
  group   => 'ubuntu',
  mode    => '0700',
  recurse => true,
}

file{'/home/ubuntu/.ssh':
  ensure  => directory,
  mode    => '0700',
  owner   => 'ubuntu',
  group   => 'ubuntu',
}

exec{'/usr/bin/git clone https://github.com/francois/dotfiles /home/ubuntu/dotfiles':
  user    => 'ubuntu',
  creates => '/home/ubuntu/dotfiles',
  require => [
    File['/home/ubuntu'],
  ],
}

exec{'/usr/bin/createuser ubuntu':
  unless => '/usr/bin/psql --list | /bin/grep ubuntu',
  user   => 'postgres',
}

exec{'/usr/bin/createdb -O ubuntu ubuntu':
  unless  => '/usr/bin/psql --list | /bin/grep ubuntu',
  user    => 'postgres',
  require => Exec['/usr/bin/createuser ubuntu'],
}

user{'ubuntu':
  ensure         => present,
  managehome     => true,
  home           => '/home/ubuntu',
  gid            => 'ubuntu',
  shell          => '/bin/zsh',
  require        => [
    Package['zsh'],
  ],
}

   exec{'/home/ubuntu/dotfiles/relink':         user => 'ubuntu', cwd => '/home/ubuntu/dotfiles', environment => 'HOME=/home/ubuntu', require => User['ubuntu']}
-> exec{'/usr/bin/byobu-select-backend screen': user => 'ubuntu', cwd => '/home/ubuntu',          environment => 'HOME=/home/ubuntu', require => User['ubuntu']}
-> exec{'/usr/bin/byobu-ctrl-a screen':         user => 'ubuntu', cwd => '/home/ubuntu',          environment => 'HOME=/home/ubuntu', require => User['ubuntu']} 
-> exec{'/usr/bin/byobu-enable':                user => 'ubuntu', cwd => '/home/ubuntu',          environment => 'HOME=/home/ubuntu', require => User['ubuntu']}
