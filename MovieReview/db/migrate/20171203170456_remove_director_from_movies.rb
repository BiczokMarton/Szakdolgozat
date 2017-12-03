class RemoveDirectorFromMovies < ActiveRecord::Migration[5.1]
  def change
    remove_column :movies, :director, :string
    remove_column :movies, :description, :text
  end
end
