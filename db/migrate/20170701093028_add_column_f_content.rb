class AddColumnFContent < ActiveRecord::Migration[5.0]
  def change
  	add_column :films, :f_content, :text
  end
end
