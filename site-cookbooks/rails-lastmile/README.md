Description
===========
Configures a server for rails hosting. Delegates as much as possible to
other cookbooks & ties everything together.

Requirements
============
Currently requires ruby_build, rb_env, apt, nginx, runit, unicorn

Attributes
==========
app_dir location on remote system where rails project will be found.
Defaults to "/vagrant".

Usage
=====

Vagrant
-------
Vagrant is the first environment rails-lastmile supports. I based my
build off of the lucid64 base box. In order to use with vagrant make a
Vagrantfile something like this:

```ruby
 config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks","cookbooks-src"]

    chef.add_recipe "apt"
    chef.add_recipe "ruby_build"
    chef.add_recipe "rbenv::system"
    chef.add_recipe "rbenv::vagrant"
    chef.add_recipe "nginx"
    chef.add_recipe "unicorn"
    chef.add_recipe "rails-lastmile"

    chef.json = {
      'rvm' => {
        'default_ruby' => 'ruby-1.9.2-p290',
        'gem_package' => {
          'rvm_string' => 'ruby-1.9.2-p290'
        }
      }
    }

  end
```

Installation
============
For a more thorough guide visit:
http://blog.119labs.com/2012/03/rails-vagrant-chef/ 

I suggest installing through librarian-chef.  In order to do so add the
following to your Cheffile:

```ruby
cookbook 'rails-lastmile',
  :git => 'git://github.com/DanThiffault/rails-lastmile.git'
```

If you're planning on making changes to the lastmile config. I'd suggest
vendoring the git repo into cookbooks-src


