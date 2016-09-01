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

module ActiveModelSerializers::Jsonapi
  MEDIA_TYPE = 'application/vnd.api+json'.freeze
  HEADERS = {
    response: { 'CONTENT_TYPE'.freeze => MEDIA_TYPE },
    request:  { 'ACCEPT'.freeze => MEDIA_TYPE }
  }.freeze
  module ControllerSupport
    def serialize_jsonapi(json, options)
      options[:adapter] = :json_api
      options.fetch(:serialization_context) { options[:serialization_context] = ActiveModelSerializers::SerializationContext.new(request) }
      get_serializer(json, options)
    end
  end
end

# actionpack/lib/action_dispatch/http/mime_types.rb
Mime::Type.register ActiveModelSerializers::Jsonapi::MEDIA_TYPE, :jsonapi

parsers = Rails::VERSION::MAJOR >= 5 ? ActionDispatch::Http::Parameters : ActionDispatch::ParamsParser
media_type = Mime::Type.lookup(ActiveModelSerializers::Jsonapi::MEDIA_TYPE)

# Proposal: should actually deserialize the JSON API params
# to the hash format expected by `ActiveModel::Serializers::JSON`
# actionpack/lib/action_dispatch/http/parameters.rb
parsers::DEFAULT_PARSERS[media_type] = lambda do |body|
  data = JSON.parse(body)

  if data.is_a?(Hash)
    type = data['data']['type'].singularize

    data = { type => ActiveModelSerializers::Deserialization.jsonapi_parse(data) }
  else
    data = { :_json => data }
  end

  data.with_indifferent_access
end

# ref https://github.com/rails/rails/pull/21496
ActionController::Renderers.add :jsonapi do |json, options|
  json = serialize_jsonapi(json, options).to_json(options) unless json.is_a?(String)
  self.content_type ||= media_type
  headers.merge! ActiveModelSerializers::Jsonapi::HEADERS[:response]
  self.response_body = json
end

ActionController::Base.send :include, ActiveModelSerializers::Jsonapi::ControllerSupport
