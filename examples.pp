notify { 'hostname1': }

notify { 'hostname2': 
	message => 'Hostname: $hostname',
}

notify { 'hostname3': 
	message => "Hostname: $hostname",
}

file { '/home/extcja01/demo.txt': 
	ensure => file,
	content => "Hostname: $hostname\n",
}

#host { 'demohost.local': 
#	ensure => present,
#	ip => '127.0.0.1',
#	comment => 'demohost',
#}

#package { 'nload': 
#	ensure => present,
#}

# templates
file { 'templateexample1': 
	path => '/home/extcja01/demotpl.txt',
	ensure => file, 
	content => template('/home/extcja01/Coding/puppet-training/template1.erb'),
}

# if
if $memorysize_mb*1 > 1024 {
	notify { 'memory1': 
		message => 'Memory > 1024',
	}
}
else {
	notify { 'memory1': 
		message => 'Memory < 1024',
	}
}

# unless - inverse if
unless $memorysize_mb*1 < 1024 {
	notify { 'memory2': 
                message => 'Memory > 1024', 
        }
}

# case statements
case $operatingsystem {
	'Solaris': { notify{ 'OS': message => 'Solaris', }}
	'Fedora': { notify{ 'OS': message => 'Fedora', }}
	default: { notify{ 'OS': message => 'unknown', }}
}

# selectors
$rootgroup = $osfamily ? {
	'Solaris'          => 'wheel',
	/(Darwin|FreeBSD)/ => 'wheel',
	default            => 'root',
}

notify { 'passwd_owner':
	message  => $rootgroup,
}

# parameter handling
$a = ['vim', 'emacs']
$x = 'vim'
notice case $x {
	$a      : { 'an array with both vim and emacs' }
	*$a     : { 'vim or emacs'}
	default : { 'no match' }
}
