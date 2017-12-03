class RemoveMovieImgFromMovies < ActiveRecord::Migration[5.1]
  def change
    remove_column :movies, :movie_img_file_name, :string
    remove_column :movies, :movie_img_content_type, :string
    remove_column :movies, :movie_img_file_size, :integer
    remove_column :movies, :movie_img_updated_at, :datetime
  end
end
