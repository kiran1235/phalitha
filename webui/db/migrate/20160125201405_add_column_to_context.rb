class AddColumnToContext < ActiveRecord::Migration
  def change
    add_column :contexts, :hashkey, :text
  end
end
