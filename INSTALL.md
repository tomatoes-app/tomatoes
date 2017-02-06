# Install Tomateos
### Required dependencies

Required dependencies trough Packet-Managers/Manual installation:
* Ruby >= 2.3.3
* Ruby-Gems
* MongoDB (More installation instructions at: https://docs.mongodb.com/manual/administration/install-on-linux/ for your desired distribution)

If you wan't to install it with RVM, you will need RVM of course too.
##### Install ruby with RVM(works with nearly all distros)

Install RVM:
```
su
$PackageManager install rvm
```
Replace $PackageManager with your desired manager ;)


With RVM now install ruby in version 2.3.3(No root required):
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
```
su
yum install mongodb
apt-get install mongodb
```

Fire up MongoDB:
`sudo service mongodb start`

And proceed with the `gem` install.
##### Installation trough distributions Packet Manager:
Get root permissions first, at best with `su`.
* APT(Debian(testing)): `apt-get install ruby2.3 mongodb rubygems `
  * Debian(stable) is actually at Ruby 2.1.. therefore you need the testing version or install ruby yourself: https://www.ruby-lang.org/en/documentation/installation/
* APT(Ubuntu): `apt-get install ruby mongodb rubygems`  (I'm actually not sure about the version in the repos -> http://packages.ubuntu.com/yakkety/ruby says it's on 2.3.0 at the moment, but since Ubuntu is (basically) based on Debian testing, it could be a newer one, AND the library(libruby) is at 2.3.1 with all other dependencies, but the Metapackage only not.)
* Yum(Fedora): `yum install ruby mongodb rubygems`


#### Install bundler and other gems
```sh
su
gem update --system #update systems gems.
gem install bundler #install bundler
gem install rake #install rake
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
