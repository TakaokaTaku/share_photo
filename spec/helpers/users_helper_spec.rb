RSpec.describe UsersHelper, type: :helper do
  let(:user) { FactoryBot.create(:user) }
  DEFAULT_ICON_SIZE = 50

  describe "icon" do
    context 'user is nil' do
      it 'displays default icon' do
        expect(icon()).to eq(image_tag( "default_icon.svg", size: "#{DEFAULT_ICON_SIZE}x#{DEFAULT_ICON_SIZE}" ))
      end
    end
    context 'user has no picture' do
      it 'displays default icon' do
        expect(icon(user)).to eq(image_tag( "default_icon.svg", size: "#{DEFAULT_ICON_SIZE}x#{DEFAULT_ICON_SIZE}" ))
      end
    end
    context 'user has user.picture' do
      it 'displays default icon' do
        user.picture = fixture_file_upload("#{Rails.root}/spec/fixtures/kitten.jpg")
        expect(icon(user)).to include("kitten.jpg")
      end
    end
  end
end
