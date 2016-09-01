class Api::AuthorsController < ApplicationController
  respond_to :json, :jsonapi

  def show
    @record = Author.find(params[:id])

    respond_with @record
  end

  def update
    STDERR.puts request.format.inspect

    STDERR.puts params.inspect
    # parsed_hash = ActiveModelSerializers::Deserialization.jsonapi_parse(params)
    #
    # STDERR.puts parsed_hash.inspect

    render text: ''
  end
end
