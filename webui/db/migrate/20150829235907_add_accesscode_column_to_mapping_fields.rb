class AddAccesscodeColumnToMappingFields < ActiveRecord::Migration
  def change
    add_column :mapping_fields, :accesscode, :text
  end
end
