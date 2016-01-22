class AddColumnsToMapppings < ActiveRecord::Migration
  def change
      add_column :mappings, :sourcefilepath, :text
      add_column :mappings, :targetfilepath, :text
      add_column :mappings, :sourcefilename, :text
      add_column :mappings, :targetfilename, :text
      add_column :mappings, :databasetype, :string
      add_column :mappings, :hostname, :string
      add_column :mappings, :portno, :int
      add_column :mappings, :encoding, :string
      add_column :mappings, :databasename, :text
      add_column :mappings, :username, :string
      add_column :mappings, :accesscode, :string
      add_column :mappings, :sourcename, :text
      add_column :mappings, :targetname, :text
      #drop_table :mapping_properties
  end
end
