require 'hovercraft/loader'
require 'hovercraft/helpers'
require 'hovercraft/filters'
require 'hovercraft/routes'
require 'sinatra/base'
require 'rack/contrib/post_body_content_type_parser'
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
      application = generate_filters(application)
      application = generate_routes(application)
      application
    end

    def configure(application)
      application.register(Hovercraft::Helpers)
      application.register(Hovercraft::Filters)
      application.register(Hovercraft::Routes)
      application.use(Rack::PostBodyContentTypeParser)
      application
    end

    def generate_filters(application)
      Hovercraft::Filters.public_instance_methods.each do |filter|
        application.send(filter)
      end

      application
    end

    def generate_routes(application)
      with_each_model do |model_class, model_name, plural_model_name|
        Hovercraft::Routes.public_instance_methods.each do |route|
          application.send(route, model_class, model_name, plural_model_name)
        end
      end

      application
    end
  end
end
