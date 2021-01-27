class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.integer :liker_id
      t.integer :liked_id

      t.timestamps
    end
    add_index :favorites, :liker_id
    add_index :favorites, :liked_id
    add_index :favorites, [:liker_id, :liked_id], unique: true
  end
end
