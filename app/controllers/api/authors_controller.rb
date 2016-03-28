class Api::AuthorsController < ApplicationController
  respond_to :json

  def show
    @record = Author.find(params[:id])

    respond_with @record
  end
end
