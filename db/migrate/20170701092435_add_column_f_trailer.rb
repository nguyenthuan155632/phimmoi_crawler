class AddColumnFTrailer < ActiveRecord::Migration[5.0]
  def change
  	add_column :films, :f_trailer, :string
  end
end
