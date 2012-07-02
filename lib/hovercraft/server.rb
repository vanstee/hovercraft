require 'hovercraft/builder'

module Hovercraft
  class Server
    def initialize
      builder = Builder.new
      @application = builder.application
    end

    def call(env)
      @application.call(env)
    end
  end
end
