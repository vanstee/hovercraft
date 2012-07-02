require 'sinatra/base'

module Hovercraft
  module Actions
    def generate_index(model_class, model_name, plural_model_name)
      get("/#{plural_model_name}.:format") do
        model_instances = model_class.all
        status 200
        model_instances.to_json
      end
    end

    def generate_create(model_class, model_name, plural_model_name)
      post("/#{plural_model_name}.:format") do
        model_instance = model_class.create(params[model_name.to_sym])
        status model_instance.valid? ? 201 : 400
        model_instance.to_json
      end
    end

    def generate_show(model_class, model_name, plural_model_name)
      get("/#{plural_model_name}/:id.:format") do
        model_instance = model_class.find(params[:id])
        status 200
        model_instance.to_json
      end
    end

    def generate_update(model_class, model_name, plural_model_name)
      put("/#{plural_model_name}/:id.:format") do
        model_instance = model_class.find(params[:id])
        model_instance.update_attributes(params[model_name.to_sym])
        status model_instance.valid? ? 204 : 400
        model_instance.to_json
      end
    end

    def generate_destroy(model_class, model_name, plural_model_name)
      delete("/#{plural_model_name}/:id.:format") do
        model_instance = model_class.find(params[:id])
        model_instance.destroy
        status 204
        model_instance.to_json
      end
    end
  end
end
