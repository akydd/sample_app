class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.string :content

      t.timestamps
    end
    add_index :messages, [:from_user_id, :created_at]
    add_index :messages, [:to_user_id, :created_at]
  end
end
