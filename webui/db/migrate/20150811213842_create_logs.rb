class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.column :whatid, :string, :null => false, index: true
      t.column :whoid, :int, :null => false, index: true
      t.column :logdata, :text, :limit => 16777216, :null => false
      t.column :createddate, :timestamp
      t.column :modifieddate, :timestamp
    end
  end
end
