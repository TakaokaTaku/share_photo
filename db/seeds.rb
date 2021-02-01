ActiveStorage::AnalyzeJob.queue_adapter = :inline
ActiveStorage::PurgeJob.queue_adapter   = :inline

# メインのサンプルユーザーを1人作成する
User.create!(name:                  "Example User",
             account_name:          "testuser",
             email:                 "example@user.org",
             tel:                   "000-0000-0000",
             password:              "foobar",
             password_confirmation: "foobar",
             activated:             true,
             activated_at:          Time.zone.now)

# メインのサンプルユーザーを2人目を作成する
User.create!(name:                  "Another User",
             account_name:          "testuser0",
             email:                 "another@user.org",
             tel:                   "000-0000-0000",
             password:              "hogehoge",
             password_confirmation: "hogehoge",
             activated:             true,
             activated_at:          Time.zone.now)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  account_name = "testuser#{n+1}"
  email = "example-#{n+1}@user.org"
  tel = "000-0000-0000"
  password = "password"
  User.create!(name:                  name,
               account_name:          account_name,
               email:                 email,
               tel:                   tel,
               password:              password,
               password_confirmation: password,
               activated:             true,
               activated_at:          Time.zone.now)
end

users = User.order(:created_at).take(6)
content = Faker::Lorem.sentence(word_count: 5)
10.times do
  users.each do |user|
    post = user.posts.build(content: content)
    post.image.attach(io: File.open('db/sample/test_image.jpg'),
                filename: 'test_image.jpg', content_type: 'image/jpeg')
    post.save!
  end
end

users = User.all
user  = users.first
posts = Post.all
post  = posts.last

following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

liking = posts[0..25]
likers = users[1..10]
liking.each { |liked| user.like(liked) }
likers.each { |liker| liker.like(post) }

senders = users[1..10]
getters = posts[0..25]
senders.each { |sender| sender.comments.create!(getter_id: post.id,
                                                  content: content) }
getters.each { |getter| user.comments.create!(getter_id: getter.id,
                                                content: content) }

comments = Comment.all
comment = comments.first
visitor = users.second
visited = users.first

visitor.active_notices.create(
  visited_id: visited.id,
  action: 'follow'
)
visitor.active_notices.create(
  post_id: post.id,
  visited_id: visited.id,
  action: 'like'
)
visitor.active_notices.create(
  post_id: post.id,
  comment_id: comment.id,
  visited_id: visited.id,
  action: 'comment'
)
