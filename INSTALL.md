# Install Tomatoes

## Clone it!
Of course, you will need a local copy of this repo. Just clone it:
```sh
git clone https://github.com/tomatoes-app/tomatoes
```
### Required dependencies

Required dependencies trough Packet-Managers/Manual installation:
* Ruby == 2.3.3
* Ruby-Gems
* MongoDB (More installation instructions at: https://docs.mongodb.com/manual/administration/install-on-linux/ for your desired distribution)

If you wan't to install it with RVM, you will need RVM of course too.
##### Install ruby with RVM

RVM is currently only in the repositorys of Fedora, so other distros have to manually install it without the package managers.

###### Fedora:
```sh
su
yum install rvm
```
###### Other Distros(Debian, Ubuntu, Gentoo etc.)...
...needs to manually install it. Complete instructions at the [RVM Homepage](https://rvm.io/). Covered here is the "easy and short" installation, for a more secure one, please [Just look at the RVM Homepage](https://rvm.io/rvm/security).

You need to get the GPG-public key, into your local keyring,  to verify the signatures of the releases:
```sh
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
```

And then install RVM:
```sh
\curl -sSL https://get.rvm.io | bash -s stable
```

Again: This is the *easiest* way. The [*secure*](https://rvm.io/rvm/security) way is the recommendet one on all production machines! 

#### Use RVM to download and install a ruby release to your local home-user directory(~)

With RVM now install ruby in version 2.3.3(without root permissions!):
```sh
rvm use 2.3.3 --install --binary --fuzzy
```
Output will be most likely something like: 

```
ruby-2.3.3 is not installed - installing.
[...]
Using ~/.rvm/gems/ruby-2.3.3
```

Now you have only to install mongodb yourself:
###### Fedora
```sh
su #get root
yum install mongodb #fedora/RHEL(5/6)
```
###### Debian
```
su #get root
apt-get install mongodb #Debian, Ubuntu
```

Fire up MongoDB:
`sudo service mongodb start`

And proceed with the `gem` install.

#### Install bundler and other gems

```sh
su
gem update --system #update systems gems.
gem install bundler #install bundler
```

And finally install all other dependencies, with `bundle`, which you can find in the Gemfile:

```sh
su
bundle install
```

#### Testing
To test your installation, use `bundle exec rake test`, and then `bundle exec rubocop -R`.
Bonus points to find out yourself if all went good.  :wink:
### optional dependencies(e.g. tests)
///@todo
