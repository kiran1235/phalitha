class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :createddate, :timestamp
      t.column :modifieddate, :timestamp
    end
  end
end
