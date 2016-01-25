class CreateContextpermissions < ActiveRecord::Migration
  def change
    create_table :contextpermissions do |t|

      t.timestamps
    end
  end
end
