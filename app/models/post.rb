class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :passive_favorites,  class_name:   "Favorite",
                               foreign_key:   "liked_id",
                                 dependent:   :destroy
  has_many :likers,                through:   :passive_favorites,
                                    source:   :liker

  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, presence: true,
                      length: { maximum: 140 }
  validates :image,   presence: true,
                      content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message: "should be less than 5MB" }

  def display_image
    image.variant(resize_to_fill: [320, 320])
  end
end
