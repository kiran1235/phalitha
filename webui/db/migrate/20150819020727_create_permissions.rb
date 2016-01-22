class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.belongs_to :mapping, index: true
      t.belongs_to :instance, index: true
      t.column :name, :string
      t.column :islocked, :boolean
      t.column :isdisabled, :boolean
      t.column :createddate, :timestamp
      t.column :modifieddate, :timestamp
    end
  end
end
