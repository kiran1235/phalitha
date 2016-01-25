class CreateContexts < ActiveRecord::Migration
  def change
    create_table :contexts do |t|
      t.belongs_to :instance, index: true
      t.text :rawdata, :limit => 16777216, :null => false
      t.timestamps
    end
  end
end
