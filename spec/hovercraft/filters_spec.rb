require 'hovercraft/filters'
require 'hovercraft/helpers'
require 'sinatra'
require 'rack/test'

describe Hovercraft::Filters do
  include Rack::Test::Methods

  let(:application) { Sinatra.new }

  alias :app :application

  before do
    application.register(Hovercraft::Helpers)
    application.register(Hovercraft::Filters)
  end

  describe '#generate_authentication_filter' do
    before do
      application.generate_authentication_filter
    end

    it 'generates a global filter' do
      application.filters[:before][0][0] == //
    end

    it 'authenticates a request' do
      block = application.filters[:before][0][3]
      block.should_receive(:[])

      get '/'
    end
  end
end
