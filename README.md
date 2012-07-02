# Hovercraft

[![Build Status](https://secure.travis-ci.org/vanstee/hovercraft.png)](http://travis-ci.org/vanstee/hovercraft)
[![Dependency Status](https://gemnasium.com/vanstee/hovercraft.png)](https://gemnasium.com/vanstee/hovercraft)

Generate a RESTful API from a directory of ActiveRecord models.

## Get Up and Running

1. Throw this in your Gemfile:

   `gem 'hovercraft'`

2. Put your ActiveRecord models in `models/` (make sure the file names
   are the same as the class names).

3. Create a rackup file that generates the application:

   ```ruby
   run Hovercraft::Server.new
   ``` 

4. Run the application like normal:

   `bundle exec rackup`

## Give Back

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
