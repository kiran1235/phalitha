class CreateMappings < ActiveRecord::Migration
  def change
    create_table :mappings do |t|
      t.belongs_to :instance, index: true
      t.column :name, :string
      t.column :description, :text
      t.column :environment, :string
      t.column :sourcetype, :string
      t.column :createddate, :timestamp
      t.column :modifieddate, :timestamp
    end
  end
end
