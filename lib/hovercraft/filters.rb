module Hovercraft
  module Filters
    def generate_authentication_filter
      before do
        authenticate_with_warden
      end
    end
  end
end
