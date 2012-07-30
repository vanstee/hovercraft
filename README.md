# Hovercraft

[![Build Status](https://secure.travis-ci.org/vanstee/hovercraft.png)](http://travis-ci.org/vanstee/hovercraft)
[![Dependency Status](https://gemnasium.com/vanstee/hovercraft.png)](https://gemnasium.com/vanstee/hovercraft)

Generate a RESTful API from a directory of ActiveRecord models.

## Short Disclaimer

I am not yet running this in production and the gem is not very
extensible at this point. Consider it a proof of concept.

## Get Up and Running

1. Throw this in your Gemfile:

   ```ruby
   gem 'hovercraft'
   ```

2. Put your ActiveRecord models in `models/` (make sure the file names
   are the same as the class names).

   Here's an example:

   ```ruby
   # models/employee.rb

   class Employee < ActiveRecord::Base
      attr_accessible :name, :career
   end
   ```

   If you need help setting up an entire sinatra app here's a full
   example: http://github.com/vanstee/hovercraft_example

3. Create a rackup file that generates the application:

   ```ruby
   # config.ru

   require 'bundler'
   Bundler.require

   run Hovercraft::Server.new
   ```

   If you need more setup I'd recommend using an `application.rb` file
   and requiring that in the `config.ru` instead.

4. Run the application like normal:

   ```
   bundle exec rackup
   ```

5. Make some requests:

   Create a record:

   ```bash
   curl -H 'Content-type: application/json' \
         -X POST \
         -d '{ "employee": { "name": "Philip J. Fry", "career": "Delivery Boy 1st Class" } }' \
         http://localhost:9292/employees.json
   ```

   Show all records:

   ```bash
   curl http://localhost:9292/employees.json
   ```

   Show a single record:

   ```bash
   curl http://localhost:9292/employees/1.json
   ```

   Update a record:

   ```bash
   curl -H "Content-type: application/json" \
         -X PUT \
         -d '{ "employee": { "name": "Philip J. Fry", "career": "Executive Delivery Boy" } }' \
         http://localhost:9292/employees/1.json
   ```

   Delete a record:

   ```bash
   curl -X DELETE http://localhost:9292/employees/1.json
   ```

## Authentication

1. Include `warden` in your Gemfile:

   ```ruby
   gem 'warden'
   ```

2. Use rack builder to add warden strategies to your rackup file:

   ```ruby
   # config.ru

   require 'bundler'
   Bundler.require

   application = Rack::Builder.new do
     use Rack::Session::Cookie, secret: '...'

     Warden::Strategies.add :password do
       def valid?
         ...
       end

       def authenticate
         ...
       end
     end

     use Warden::Manager do |manager|
       manager.default_strategies :password
       manager.failure_app = ...
     end

     run Hovercraft::Server
   end

   run application
   ```

See the [warden project](https://github.com/hassox/warden/) for more in-depth examples or help troubleshooting.

## Give Back

1. Fork it:

   https://help.github.com/articles/fork-a-repo

2. Create your feature branch:

   ```bash
   git checkout -b fixes_horrible_spelling_errors
   ```

3. Commit your changes:

   ```bash
   git commit -am 'Really? You spelled application as "applickachon"?'
   ```

4. Push the branch:

   ```bash
   git push origin fixes_horrible_spelling_errors
   ```

5. Create a pull request:

   https://help.github.com/articles/using-pull-requests
