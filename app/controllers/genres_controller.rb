class GenresController < ApplicationController
  before_action :require_signin, except: [:index, :show] 
  before_action :require_admin, except: [:index, :show]

  def index 
    @genres = Genre.all.order(:name)
  end

  def new 
    @genre = Genre.new()
  end

  def create 
    @genre = Genre.new(genre_params)
    if @genre.save 
      redirect_to @genre, message: "Genre '#{@genre.name}' successfully added!"
    else 
      render :new, status: :unprocessable_entity
    end
  end 

  def show
    @genre = Genre.find(params[:id])
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      redirect_to @genre, notice: "Genre '#{@genre.name}' successfully updated!" 
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @genre = Genre.find(params[:id])
    @genre.destroy 
    redirect_to genres_path, status: :see_other, alert: "Genre '#{@genre.name}' successfully deleted!"
  end

  private 

  def genre_params
    params.require(:genre).permit(:name)
  end
end
