class Api::CommentsController < ApplicationController
  respond_to :json

  def show
    @record = Comment.find(params[:id])

    respond_with @record
  end
end
