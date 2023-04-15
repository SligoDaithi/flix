class ReviewsController < ApplicationController

  before_action :set_movie 
  before_action :require_signin 

  def index
    @reviews = @movie.reviews 
  end

  def new 
    @review = @movie.reviews.new()
  end

  def create 
    @review = @movie.reviews.new(review_params) 
    @review.user = current_user 
    if @review.save 
      redirect_to movie_reviews_path(@movie), message: "Review for '#{@movie.title}' successfully created by #{@review.user.name}!"
    else 
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @review = @movie.reviews.find(params[:id])
  end

  def update
    @review = @movie.reviews.find(params[:id])
    if @review.update(review_params)
      redirect_to movie_reviews_path, notice: "Movie '#{@movie.title}' successfully updated!" 
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review = @movie.reviews.find(params[:id]) 
    @review.destroy 
    redirect_to movie_reviews_path, status: :see_other, alert: "Review by '#{@review.user.name}' successfully deleted!"
  end

  private 

  def review_params
    params.require(:review).permit(:comment, :stars)
  end

  def set_movie
    @movie = Movie.find_by!(slug: params[:movie_id])
  end
end
