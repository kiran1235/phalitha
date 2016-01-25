class AddLogTypeColumnToLogs < ActiveRecord::Migration
  def change
	add_column :logs, :category, :string,  index: true
	add_column :logs, :subcategory, :string, index: true
  end
end
