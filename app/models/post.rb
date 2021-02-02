class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  has_many   :passive_favorites,   class_name:  "Favorite",
                                  foreign_key:  "liked_id",
                                    dependent:  :destroy
  has_many   :likers,                 through:  :passive_favorites,
                                       source:  :liker
  has_many   :comments,           foreign_key:  "getter_id",
                                    dependent:  :destroy
  has_many   :notices,              dependent:  :destroy

  default_scope -> { order(created_at: :desc) }

  validates  :user_id, presence: true
  validates  :content, presence: true,
                         length: { maximum: 140 }
  validates  :image,   presence: true,
                   content_type: { in: %w[image/jpeg image/gif image/png],
                              message: "must be a valid image format" },
                           size: { less_than: 5.megabytes,
                                     message: "should be less than 5MB" }

  def display_image
    image.variant(resize_to_fill: [320, 320])
  end

  def create_notice_like(current_user)
    temp = Notice.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ? ",
                         current_user.id, user_id, id, 'like'])
    if temp.blank?
      notice = current_user.active_notices.new(
        post_id: id,
        visited_id: user_id,
        action: 'like'
      )
      if notice.visitor_id == notice.visited_id
        notice.checked = true
      end
      notice.save if notice.valid?
    end
  end

  def create_notice_comment(current_user, comment_id)
    notice = current_user.active_notices.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: user_id,
      action: 'comment'
    )
    if notice.visitor_id == notice.visited_id
      notice.checked = true
    end
    notice.save if notice.valid?
  end
end
