class SpotsController < ApplicationController
  def index
    @stores = Store.all
    gon.stores = @stores
  end
end
