class CreateUserpermissions < ActiveRecord::Migration
  def change
    create_table :userpermissions do |t|
      t.belongs_to :permission, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
