ActiveModelSerializers.config.adapter = :json_api

module ActionController
  module Serialization

    [:_render_option_json, :_render_with_renderer_json].each do |renderer_method|
      define_method renderer_method do |resource, options|
        options.fetch(:serialization_context) do
          options[:serialization_context] = ActiveModelSerializers::SerializationContext.new(request)
        end

        if options[:prefixes].find { |p| p.match(/v1/) }
          serializer = "#{resource.class}Version8Serializer".safe_constantize
          options[:serializer] = serializer
          options[:adapter] = :json
        end

        serializable_resource = get_serializer(resource, options)
        super(serializable_resource, options)
      end
    end

  end
end
