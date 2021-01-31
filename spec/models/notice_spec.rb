RSpec.describe Notice, type: :model do
  describe "validation" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let(:notice) { user.active_notices.new(visitor_id: user.id, visited_id: other_user.id) }

    it "is valid with test data" do
      expect(notice).to be_valid
    end

    it "is invalid without visitor_id" do
      notice.visitor_id = nil
      expect(notice).not_to be_valid
    end

    it "is invalid without visited_id" do
      notice.visited_id = nil
      expect(notice).not_to be_valid
    end
  end
end
