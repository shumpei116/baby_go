class HomesController < ApplicationController
  def top
    @stores = Store.all
    gon.stores = @stores
  end
end
