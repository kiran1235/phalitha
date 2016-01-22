class AddColumnToMapping < ActiveRecord::Migration
  def change
    add_column :mappings, :mapping_access_point, :text
  end
end
