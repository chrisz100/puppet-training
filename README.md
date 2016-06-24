# puppet training
Date: December 2015

## ToC

1. What is puppet
2. manifests
3. resources
4. syntax
5. templates
6. conditions
7. expressions & operators
8. classes
9. defined resource types
10. run stages
11. modules
12. hiera
13. environments

## Content
Stuff to be teached, explained or otherwise delivered.  
In short: Concept

### What is puppet
> homogeneous way to manage heterogeneous networks
>
> develop your infrastructure

- enforces states
- configuration management
- allows simple server scaling
- quick server setup

### manifests
- file*.pp*
- execute/ test via `$ puppet apply file.pp`

### resources
- functions to be used
- describe server/ service state
- execution
- http://docs.puppetlabs.com/references/latest/type.html

### syntax
```puppet
# comment
<RESOURCE> { '<TITLE>':
  <ATTRIBUTE> => <VALUE>,
}
```

#### real world example
```puppet
# ensure /etc/passwd is present and root-rw-able only
file {'/etc/passwd':
  ensure => file,
  owner => 'root',
  group => 'root',
  mode => '0600',
}
```

- title needs to be unique
- parameterized
- allow metaparameters : https://docs.puppetlabs.com/references/latest/metaparameter.html

### templates
- `erb`-syntax
- `<%= @fqdn %>`

more: https://docs.puppetlabs.com/puppet/latest/reference/lang_template_erb.html

#### syntax
```ruby
<%# Non-printing tag ↓ -%>
<% if @keys_enable -%>
<%# Expression-printing tag ↓ -%>
keys <%= @keys_file %>
<% unless @keys_trusted.empty? -%>
trustedkey <%= @keys_trusted.join(' ') %>
<% end -%>
<% if @keys_requestkey != '' -%>
requestkey <%= @keys_requestkey %>
<% end -%>
<% if @keys_controlkey != '' -%>
controlkey <%= @keys_controlkey %>
<% end -%>

<% end -%>
```

#### tags
- `<%= EXPRESSION %>` — Inserts the value of an expression.
- With `-%>` — Trims the following line break.
- `<% CODE %>` — Executes code, but does not insert a value.
- With `<%-` — Trims the preceding indentation.
- With `-%>` — Trims the following line break.
- `<%# COMMENT %>` — Removed from the final output.
- With `-%>` — Trims the following line break.
- `<%%` or `%%>` — A literal `<%` or `%>`, respectively.

### conditions
- if, elseif, else
- unless (inverse if)
- case
- selectors (for variables)
- allows regexp

### expressions & operators
see more: http://docs.puppetlabs.com/puppet/latest/reference/lang_expressions.html

### classes
- executed only once
- can have parameters/ header

### defined resource types
- `catalog n-n defined resource type`
- `catalog n-n use of defined resource type`

#### syntax
```puppet
define apache::vhost (Integer $port, String[1] $docroot, String[1] $servername = $title, String $vhost_name = '*') {
  include apache # contains Package['httpd'] and Service['httpd']
  include apache::params # contains common config settings
  $vhost_dir = $apache::params::vhost_dir
  file { "${vhost_dir}/${servername}.conf":
    content => template('apache/vhost-default.conf.erb'),
      # This template can access all of the parameters and variables from above.
    owner   => 'www',
    group   => 'www',
    mode    => '644',
    require => Package['httpd'],
    notify  => Service['httpd'],
  }
}
```

### run stages
- easy sorting
- ensure preconditions for services are met

```puppet
# define stages
stage { 'First': }

stage { 'Second':
  before => Stage['main'],
}

# connect classes to stages
class {'apt-keys':
  stage => First, # metaparameter
}

class {'middleware':
  stage => Second, # metaparameter
}

# Sort stages
Stage['First'] -> Stage['Second']
```

more: https://docs.puppetlabs.com/puppet/latest/reference/lang_run_stages.html

### modules
- separated directory
- structure manifests
- own templates, libs, manifests
- needs init.pp

### hiera
- database
- hierarchical
- supports multiple backends
  - yaml
  - eyaml (encrypted yaml)
  - databases
  - ...

```puppet
$demo = hiera('value')
```

### environments
- per folder
- no hierarchy -> exclusive
- allows easy testing
- `server n-1 environment`
