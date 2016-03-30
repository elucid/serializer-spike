ActiveModelSerializers.config.adapter = :json_api

module ActionController
  module Serialization

    [:_render_option_json, :_render_with_renderer_json].each do |renderer_method|
      define_method renderer_method do |resource, options|
        options.fetch(:serialization_context) do
          options[:serialization_context] = ActiveModelSerializers::SerializationContext.new(request)
        end

        case request.path
        when %r<api/v1>
          # serializer = "#{resource.class}Version8Serializer".safe_constantize
          json = ActiveModel::SerializerVersion8.build_json(self, resource, options)

          if json
            super(json, options)
          else
            super(resource, options)
          end
        when %r<api/v2>
          options[:include] = params[:include]

          if params[:fields].present?
            params[:fields].each { |k, v| params[:fields][k] = v.split(",") }
            options[:fields] = params[:fields]
          end

          options[:sort] = params[:sort]
          options[:page] = params[:page]
          options[:filter] = params[:filter]

          serializable_resource = get_serializer(resource, options)
          super(serializable_resource, options)
        end
      end
    end

  end
end
