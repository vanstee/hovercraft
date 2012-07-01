require 'hovercraft/caller'
require 'active_support/inflector'
require 'pry'

module Hovercraft
  class Loader
    def initialize
      @caller = Caller.new
    end

    def with_each_model
      models.each do |model_class|
        model_name = model_class.name.underscore
        plural_model_name = model_name.pluralize
        yield(model_class, model_name, plural_model_name)
      end
    end

    def models
      @models ||= require_models
    end

    private

    def require_models
      Dir.glob(File.join(models_directory, '**/*.rb')).map do |file|
        require file
        class_from(file)
      end
    end

    def models_directory
      File.join(@caller.directory, 'models')
    end

    def class_from(file)
      file.gsub!(/#{models_directory}|.rb/, '')
      file.classify.safe_constantize
    end
  end
end
