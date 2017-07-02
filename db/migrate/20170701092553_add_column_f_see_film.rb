class AddColumnFSeeFilm < ActiveRecord::Migration[5.0]
  def change
  	add_column :films, :f_see_film, :string
  end
end
