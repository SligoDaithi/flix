module FavoritesHelper
  def fave_or_unfave_button(movie, favorite) 
    unless favorite.present?
      button_to "♥️ Fave", movie_favorites_path(movie)
    else
      button_to "♡ Unfave", movie_favorite_path(movie, favorite), method: :delete
    end
  end
end
