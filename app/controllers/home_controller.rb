class HomeController < ApplicationController
  def index
    (@countries = Country.order(:name).all) if current_shop
  end
  def help
  end
end