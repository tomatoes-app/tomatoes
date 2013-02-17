# ![Tomatoes](https://github.com/potomak/tomatoes/raw/develop/app/assets/images/tomatoes_logo_48.png "Tomatoes") Tomatoes

Try it for free at [http://tomato.es](http://tomato.es "Tomatoes")

[![Flattr Tomatoes](http://api.flattr.com/button/flattr-badge-large.png)](http://flattr.com/thing/376437/Tomatoes "Flattr Tomatoes")

## Why?

1. [Pomodoro technique](http://www.pomodorotechnique.com)<sup>®</sup> helps you to get things done.
1. I need it to measure pomodoros in a fast and easy way.
1. I want to get motivated by challenging my friends.

## How to setup a development virtual server with Virtualbox

1. Install Virtualbox (see https://www.virtualbox.org/wiki/Downloads).
1. Fork the project on github and clone the repo.
1. Run `bundle install` to install required gems.
1. Run `librarian-chef` to install required cookbooks.
1. Run `vagrant up` to start a virtual machine containing the app (this process can take a few minutes).
1. Open http://localhost:8080 on your browser.

## License

Tomatoes is released under the MIT license.

## How to contribute

If you find what looks like a bug:

1. Check the [GitHub issue tracker](https://github.com/potomak/tomatoes/issues) to see if anyone else has reported issue.
1. If you don’t see anything, create an issue with information on how to reproduce it.

If you want to contribute an enhancement or a fix:

1. Fork the project on github.
1. Make your changes with tests.
1. Commit the changes without making changes to the Rakefile or any other files that aren’t related to your enhancement or fix
1. Send a pull request.

## Build Status [![Build Status](https://secure.travis-ci.org/potomak/tomatoes.png?branch=develop)](http://travis-ci.org/potomak/tomatoes)
