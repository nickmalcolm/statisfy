class HomeController < ApplicationController
  def index
    @countries = Country.order(:name).all
  end
end