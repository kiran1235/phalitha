class AddMonitorStatusColumnToMapping < ActiveRecord::Migration
  def change
	add_column :mappings, :iswatching, :integer
  end
end
