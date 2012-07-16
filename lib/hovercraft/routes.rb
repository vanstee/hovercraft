module Hovercraft
  module Routes
    def generate_index(model_class, model_name, plural_model_name)
      get(%r{^/#{plural_model_name}(\.(?<format>[^\./?#]+))?$}) do
        model_instances = model_class.all
        status 200
        respond_with model_instances
      end
    end

    def generate_create(model_class, model_name, plural_model_name)
      post(%r{^/#{plural_model_name}(\.(?<format>[^\./?#]+))?$}) do
        model_instance = model_class.create(params[model_name.to_sym])
        status model_instance.valid? ? 201 : 400
        respond_with model_instance
      end
    end

    def generate_show(model_class, model_name, plural_model_name)
      get(%r{^/#{plural_model_name}/(?<id>[^\./?#]+)(\.(?<format>[^\./?#]+))?$}) do
        model_instance = model_class.find(params[:id])
        status 200
        respond_with model_instance
      end
    end

    def generate_update(model_class, model_name, plural_model_name)
      put(%r{^/#{plural_model_name}/(?<id>[^\./?#]+)(\.(?<format>[^\./?#]+))?$}) do
        model_instance = model_class.find(params[:id])
        model_instance.update_attributes(params[model_name.to_sym])
        status model_instance.valid? ? 204 : 400
        respond_with model_instance
      end
    end

    def generate_destroy(model_class, model_name, plural_model_name)
      delete(%r{^/#{plural_model_name}/(?<id>[^\./?#]+)(\.(?<format>[^\./?#]+))?$}) do
        model_instance = model_class.find(params[:id])
        model_instance.destroy
        status 204
        respond_with model_instance
      end
    end
  end
end
