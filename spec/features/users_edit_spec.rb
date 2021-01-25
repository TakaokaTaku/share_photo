RSpec.describe "UsersEdits", type: :system do
  let(:user) { FactoryBot.create(:user) }

  context 'edit user infomation' do
    it 'fails edit with wrong information' do
      login_as(user)

      visit user_path(user)
      click_on 'プロフィール 編集'
      fill_in '名前', with: ' '
      fill_in 'アカウント名', with: ' '
      fill_in 'メールアドレス', with: 'user@invalid'
      fill_in '電話番号', with: ' '
      click_on 'プロフィールを更新する'
      expect(current_path).to eq user_path(user)
      expect(page).to have_content "プロフィール編集"
      expect(page).to have_selector ".alert-danger"
    end

    it "succeeds edit with correct information" do
      login_as(user)

      visit user_path(user)
      expect(page).to have_content "プロフィール編集より、自己紹介や、\nウェブサイトのURLを登録できます。"
      click_on 'プロフィール 編集'
      fill_in '名前', with: 'Foo Bar'
      fill_in 'アカウント名', with: 'foo-bar-user'
      fill_in 'メールアドレス', with: 'foo@bar.com'
      fill_in '電話番号', with: '111-1111-1111'
      fill_in 'ウェブサイト', with: 'https://foobar.com'
      fill_in '自己紹介', with: 'hello world!'
      choose '女'
      attach_file 'user[picture]', "#{Rails.root}/spec/fixtures/kitten.jpg"
      click_on 'プロフィールを更新する'
      expect(current_path).to eq user_path(user)
      expect(page).to have_content user.introduction
      expect(page).to have_link user.website
      expect(page).to have_selector "img[src$='kitten.jpg']"
      expect(page).to have_selector ".alert-success"
    end
  end
  context 'edit user password' do
    it 'fails edit with wrong password' do
      login_as(user)

      visit user_path(user)
      click_on 'プロフィール 編集'
      click_on 'パスワード変更'
      fill_in '現パスワード', with: 'invalid'
      fill_in '新パスワード', with: 'invalid'
      fill_in '新パスワード（再入力）', with: 'invalid'
      click_on 'パスワードを更新する'
      expect(current_path).to eq edit_password_user_path(user)
      expect(page).to have_content "パスワード変更"
      expect(page).to have_selector ".alert-danger"
    end

    it "succeeds edit with correct password" do
      login_as(user)

      visit user_path(user)
      click_on 'プロフィール 編集'
      click_on 'パスワード変更'
      fill_in '現パスワード', with: user.password
      fill_in '新パスワード', with: 'hogehoge'
      fill_in '新パスワード（再入力）', with: 'hogehoge'
      click_on 'パスワードを更新する'
      expect(current_path).to eq user_path(user)
      expect(page).to have_selector ".alert-success"
    end
  end
end
