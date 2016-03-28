class Api::PostsController < ApplicationController
  respond_to :json

  def show
    @record = Post.find(params[:id])

    respond_with @record
  end
end
