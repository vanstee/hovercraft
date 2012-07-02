require 'hovercraft/builder'

describe Hovercraft::Builder do
  let(:model)  { stub(name: 'Robot') }
  let(:models) { Array.new(3) { model } }
  let(:params) { models.map { |m| [m, 'robot', 'robots'] } }

  before do
    subject.stub(:with_each_model).
      and_yield(*params[0]).
      and_yield(*params[1]).
      and_yield(*params[2])
  end

  describe '#application' do
    it 'creates a sinatra application' do
      subject.application.ancestors.should include(Sinatra::Base)
    end

    it 'configures the application' do
      subject.should_receive(:configure)

      subject.application
    end

    it 'generates routes for the application' do
      subject.should_receive(:generate_routes)

      subject.application
    end
  end

  describe '#configure' do
    let(:application) { stub(register: nil, use: nil) }

    it 'registers the methods to generate actions' do
      application.should_receive(:register).with(Hovercraft::Actions)

      subject.configure(application)
    end

    it 'uses a post body parsing middleware' do
      application.should_receive(:use).with(Rack::PostBodyContentTypeParser)

      subject.configure(application)
    end
  end

  describe '#generate_routes' do
    let(:application) { stub }

    it 'calls all generate methods for each model' do
      [:index, :create, :show, :update, :destroy].each do |action|
        application.should_receive("generate_#{action}").exactly(3).times
      end

      subject.generate_routes(application)
    end
  end
end
