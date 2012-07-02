require 'hovercraft/loader'
require 'hovercraft/actions'
require 'sinatra/base'
require 'rack/contrib'
require 'forwardable'

module Hovercraft
  class Builder
    extend Forwardable

    def_delegator :@loader, :with_each_model

    def initialize
      @loader = Loader.new
    end

    def application
      application = Sinatra.new
      application = configure(application)
      application = generate_routes(application)
      application
    end

    def configure(application)
      application.register(Hovercraft::Actions)
      application.use(Rack::PostBodyContentTypeParser)
      application
    end

    def generate_routes(application)
      with_each_model do |model_class, model_name, plural_model_name|
        application.methods.grep(/generate/).each do |action|
          application.send(action, model_class, model_name, plural_model_name)
        end
      end
      application
    end
  end
end
