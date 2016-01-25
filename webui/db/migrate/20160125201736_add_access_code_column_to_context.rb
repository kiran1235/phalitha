class AddAccessCodeColumnToContext < ActiveRecord::Migration
  def change
	add_column :contexts, :accesskey, :string
  end
end
