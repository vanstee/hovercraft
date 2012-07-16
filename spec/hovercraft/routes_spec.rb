require 'hovercraft/routes'
require 'hovercraft/helpers'
require 'sinatra'
require 'rack/test'

describe Hovercraft::Routes do
  include Rack::Test::Methods

  let(:application)          { Sinatra.new }
  let(:model_name)           { 'employee' }
  let(:model_name_pluralize) { 'employees' }
  let(:model_class)          { Class.new }

  let(:model) do
    stub(
      to_json:
      '
        {
          "employee": {
            "name": "Philip J. Fry",
            "career": "Intergalactic Delivery Boy"
          }
        }
      ',
      valid?: true,
      update_attributes: self,
      destroy: self
    )
  end

  let(:models) do
    stub(
      to_json:
      '
        [
          {
            "employee": {
              "name": "Philip J. Fry",
              "career": "Intergalactic Delivery Boy"
            }
          },
          {
            "employee": {
              "name": "John A. Zoidberg",
              "career": "Physician"
          }
        ]
      '
    )
  end

  alias :app :application

  before do
    application.register(Hovercraft::Helpers)
    application.register(Hovercraft::Routes)

    model_class.stub(all: models, create: model, find: model)
  end

  describe '#generate_index' do
    before do
      application.generate_index(model_class, model_name, model_name_pluralize)
    end

    it 'generates a GET collection route' do
      application.routes['GET'][0][0].should == %r{^/employees(\.(?<format>[^\./?#]+))?$}
      application.routes['GET'][0][1].should == ['format']
    end

    it 'returns a list of models' do
      get '/employees.json'

      last_response.status.should == 200
    end
  end

  describe '#generate_create' do
    before do
      application.generate_create(model_class, model_name, model_name_pluralize)
    end

    it 'generates a POST collection route' do
      application.routes['POST'][0][0].should == %r{^/employees(\.(?<format>[^\./?#]+))?$}
      application.routes['POST'][0][1].should == ['format']
    end

    it 'creates and returns a model' do
      post '/employees.json', zoidberg: { occipation: 'doctor' }

      last_response.status.should == 201
    end

    it 'fails and returns an error' do
      model.stub(valid?: false)

      post '/employees.json', employee: { name: 'Bender Bending Rodriguez', career: 'Girder-bender' }

      last_response.status.should == 400
    end
  end

  describe '#generate_show' do
    before do
      application.generate_show(model_class, model_name, model_name_pluralize)
    end

    it 'generates a GET member route' do
      application.routes['GET'][0][0].should == %r{^/employees/(?<id>[^\./?#]+)(\.(?<format>[^\./?#]+))?$}
      application.routes['GET'][0][1].should == ['id', 'format']
    end

    it 'returns a model' do
      get '/employees/1.json'

      last_response.status.should == 200
    end
  end

  describe '#generate_update' do
    before do
      application.generate_update(model_class, model_name, model_name_pluralize)
    end

    it 'generates a PUT member route' do
      application.routes['PUT'][0][0].should == %r{^/employees/(?<id>[^\./?#]+)(\.(?<format>[^\./?#]+))?$}
      application.routes['PUT'][0][1].should == ['id', 'format']
    end

    it 'updates and returns a model' do
      put '/employees/1.json'

      last_response.status.should == 204
    end

    it 'fails and returns an error' do
      model.stub(valid?: false)

      put '/employees/1.json', employee: { career: 'Unemployed' }

      last_response.status.should == 400
    end
  end

  describe '#generate_destroy' do
    before do
      application.generate_destroy(model_class, model_name, model_name_pluralize)
    end

    it 'generates a DELETE member route' do
      application.routes['DELETE'][0][0].should == %r{^/employees/(?<id>[^\./?#]+)(\.(?<format>[^\./?#]+))?$}
      application.routes['DELETE'][0][1].should == ['id', 'format']
    end

    it 'destroys and returns a model' do
      delete '/employees/1.json'

      last_response.status.should == 204
    end
  end
end
