class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.integer  :sender_id
      t.integer  :getter_id
      t.text     :content

      t.timestamps
    end
    add_index :comments, :sender_id
    add_index :comments, :getter_id
    add_index :comments, [:sender_id, :getter_id], unique: true
  end
end
