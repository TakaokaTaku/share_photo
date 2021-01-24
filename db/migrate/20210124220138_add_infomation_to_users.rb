class AddInfomationToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :user_name, :string
    add_column :users, :tel,       :string
    add_column :users, :gender,    :integer
    add_column :users, :introduction, :text
    add_column :users, :website,   :text
  end
end
