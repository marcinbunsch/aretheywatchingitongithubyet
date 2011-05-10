Are They Watching It On Github Yet?
===================================

Introducing the first Github harassment tool!

With this you can send your friends a page that will show them that they are still not following your awesome Github project!

The app lives at [aretheywatchingitongithubyet.heroku.com](http://aretheywatchingitongithubyet.heroku.com/).

Installation
------------

Clone the repo, then

	bundle install --binstubs
	bin/thin -R config.ru start


Testing
------------

RSpec with Capybara is used for testing

	bin/rspec spec

Copyright
---------

Copyright (c) 2011 Marcin Bunsch. See LICENSE for details.
