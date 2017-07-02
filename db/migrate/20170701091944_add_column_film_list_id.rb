class AddColumnFilmListId < ActiveRecord::Migration[5.0]
  def change
  	add_column :films, :film_list_id, :integer
  end
end
