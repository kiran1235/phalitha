class AddFieldAssociationToPermission < ActiveRecord::Migration
  def change
    add_column :permissions, :mapping_field_id, :integer
  end
end
