class CreateMappingsUsers < ActiveRecord::Migration
  def change
    create_table :mappings_users, id: false do |t|
      t.belongs_to :mapping, index: true
      t.belongs_to :user, index: true
    end
  end
end
