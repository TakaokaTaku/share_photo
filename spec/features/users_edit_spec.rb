RSpec.describe "UsersEdits", type: :system do
  let(:user) { FactoryBot.create(:user) }

  it 'fails edit with wrong information' do
    login_as(user)
    click_on 'Account'
    click_on 'Setting'
    fill_in 'Name', with: ' '
    fill_in 'Email', with: 'user@invalid'
    fill_in 'Password', with: 'foo'
    fill_in 'Confirmation', with: 'bar'
    click_on 'Save changes'
    expect(current_path).to eq user_path(user)
    expect(page).to have_selector ".alert-danger"
  end

  it "succeeds edit with correct information" do
    login_as(user)
    click_on 'Account'
    click_on 'Setting'
    fill_in 'Name', with: 'Foo Bar'
    fill_in 'Email', with: 'foo@bar.com'
    fill_in 'Password', with: ''
    fill_in 'Confirmation', with: ''
    click_on 'Save changes'
    expect(current_path).to eq user_path(user)
    expect(page).to have_selector ".alert-success"
  end
end
