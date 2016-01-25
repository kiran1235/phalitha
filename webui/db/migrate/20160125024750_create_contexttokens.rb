class CreateContexttokens < ActiveRecord::Migration
  def change
    create_table :contexttokens do |t|
      t.belongs_to :context, index: true
      t.string :context_token
      t.text :context_token_data, :limit => 16777216, :null => false
      t.timestamps
    end
  end
end
