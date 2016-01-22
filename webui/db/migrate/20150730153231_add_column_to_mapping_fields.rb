class AddColumnToMappingFields < ActiveRecord::Migration
  def change
    add_column :mapping_fields, :sensitivity, :text
    add_column :mapping_fields, :rawvalue, :text
    add_column :mapping_fields, :isparent, :boolean
    add_column :mapping_fields, :parentkey, :text
  end
end
