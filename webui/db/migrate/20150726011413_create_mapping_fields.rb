class CreateMappingFields < ActiveRecord::Migration
  def change
    create_table :mapping_fields do |t|
      t.belongs_to :mapping, index: true
      t.column :fieldname, :string
      t.column :datatype, :string
      t.column :searchpath, :text
    end
  end
end
