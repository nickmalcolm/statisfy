class ShopController < ApplicationController
  def show
    @shop = Shop.find_by_id(params[:id])
    @reigning = @shop.crowns.reigning
    @lost = @shop.crowns.lost
  end
end
