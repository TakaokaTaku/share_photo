RSpec.describe "Followings", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:other_users) { FactoryBot.create_list(:user, 20) }

  before do
    other_users[0..9].each do |other_user|
      user.active_relationships.create!(followed_id: other_user.id)
      user.passive_relationships.create!(follower_id: other_user.id)
    end
  end

  it "is the correct number of following and followers" do
    login_as(user)
    click_on "following"
    expect(user.following.count).to eq 10
    user.following.each do |u|
      expect(page).to have_link u.name, href: user_path(u)
    end
    visit user_path(user)
    click_on "followers"
    expect(user.followers.count).to eq 10
    user.followers.each do |u|
      expect(page).to have_link u.name, href: user_path(u)
    end
  end

  it "When user clicks on Unfollow, the number of following increases by -1" do
    login_as(user)
    visit user_path(other_users.first.id)
    expect do
      click_on "Unfollow"
      expect(page).not_to have_link "Unfollow"
      visit current_path
    end.to change(user.following, :count).by(-1)
  end

  it "When user clicks on Follow, the number of following increases by 1" do
    login_as(user)
    visit user_path(other_users.last.id)
    expect do
      click_on "Follow"
      expect(page).not_to have_link "Follow"
      # Ajaxの処理待ちの為に入れています
      visit current_path
    end.to change(user.following, :count).by(1)
  end
end
