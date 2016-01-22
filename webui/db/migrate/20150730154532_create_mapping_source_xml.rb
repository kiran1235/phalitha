class CreateMappingSourceXml < ActiveRecord::Migration
  def change
    create_table :mapping_source_xml do |t|
      t.belongs_to :mapping, index: true
      t.column :rawdata, :string
      t.column :datatype, :string
      t.column :searchpath, :text
    end
  end
end
