class CreateUsertokens < ActiveRecord::Migration
  def change
    create_table :usertokens do |t|
	  t.belongs_to :user
      t.string :data, :null => false
      t.text :requestdata, :null => false
      t.timestamps
    end
    add_index :usertokens, :data
    add_index :usertokens, :updated_at
  end  
end
