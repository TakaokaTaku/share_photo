# メインのサンプルユーザーを1人作成する
User.create!(name:                  "Example User",
             account_name:             "test-user",
             email:                 "example@railstutorial.org",
             tel:                   "000-0000-0000",
             password:              "foobar",
             password_confirmation: "foobar",
             activated:             true,
             activated_at:          Time.zone.now)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  account_name = "test-user-#{n+1}"
  email = "example-#{n+1}@railstutorial.org"
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
10.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each do |user|
    post = user.posts.build(content: content)
    post.image.attach(io: File.open('db/sample/test_image.jpg'), filename: 'test_image.jpg', content_type: 'image/jpeg')
    post.save!
  end
end

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
