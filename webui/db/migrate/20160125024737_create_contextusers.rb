class CreateContextusers < ActiveRecord::Migration
  def change
    create_table :contextusers do |t|
      t.belongs_to :context, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
