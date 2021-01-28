class Comment < ApplicationRecord

  default_scope -> { order(created_at: :desc) }
  belongs_to :sender, class_name: "User"
  belongs_to :getter, class_name: "Post"
    
  validates :sender_id, presence: true
  validates :getter_id, presence: true
  validates :content,   presence: true

end
