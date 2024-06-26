class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.create(restaurant_params)
    redirect_to restaurants_path
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    sum = 0
    @restaurant.reviews.each { |review| sum += review.rating }
    @restaurant.reviews.empty? ? @rating = 0 : @rating = sum/@restaurant.reviews.count
  end

  def search
    @query = params[:q]
    @restaurant = Restaurant.find_by(name: @query)

    if @restaurant
      redirect_to restaurant_path(@restaurant)
    else
      @results = Restaurant.where("name LIKE ?", "%#{@query}%")
      render :search_results
    end
  end

  private
  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :phone_number, :category)
  end
end
