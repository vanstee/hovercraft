module Hovercraft
  module Helpers
    def self.registered(application)
      application.helpers(Hovercraft::Helpers)
    end

    def authenticate_with_warden
      warden.authenticate! if warden
    end

    def warden
      env.fetch('warden')
    end

    def respond_with(content)
      if content.respond_to?(format_method_name)
        content.send(format_method_name)
      else
        fail "Serialization method not supported: #{format_method_name}"
      end
    end

    def format_method_name
      "to_#{format}"
    end

    def format
      params[:format] ||
      preferred_type  ||
      default_format
    end

    def preferred_type
      case request.preferred_type
      when /.*\/json/ then :json
      when /.*\/xml/  then :xml
      when /.*\/\*/   then default_format
      else fail "Unknown media type: %p" % request.preferred_type
      end
    end

    def default_format
      :json
    end
  end
end
