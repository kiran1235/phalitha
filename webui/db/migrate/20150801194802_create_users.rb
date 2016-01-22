class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column :name, :string
      t.column :username, :text
      t.column :hashkey, :string
      t.column :islocked, :boolean
      t.column :isdeleted, :boolean
      t.column :islogged, :boolean
      t.column :isexpired, :boolean
      t.column :createddate, :timestamp
      t.column :modifieddate, :timestamp
    end
  end
end
