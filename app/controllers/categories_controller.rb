class CategoriesController < ApplicationController
  respond_to :json

  def index
    respond_with Imagen.get_categories
  end
end