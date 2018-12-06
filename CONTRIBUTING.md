## How to contribute

If you find what looks like a bug:

1. Check the [GitHub issue tracker](https://github.com/tomatoes-app/tomatoes/issues) to see if anyone else has reported issue.
1. If you don’t see anything, create an issue with information on how to reproduce it.

If you want to contribute an enhancement or a fix:

1. [Fork the project](https://help.github.com/articles/fork-a-repo) on github.
1. [Create a topic branch](http://learn.github.com/p/branching.html).
1. Setup the project with [docker-compose](https://docs.docker.com/compose/) by running `docker-compose up`
1. If you need, you can launch a rails console with  `docker-compose exec web rails c`
1. Make your changes and adds/updates relevant tests.
1. Run the test suite with `docker-compose exec web rake`
1. Commit the changes without making changes to the Rakefile or any other files that aren’t related to your enhancement or fix.
1. Send a pull request.
