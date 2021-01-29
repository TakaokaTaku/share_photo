RSpec.describe Comment, type: :model do
  describe "validation" do
    let(:user) { FactoryBot.create(:user) }
    let(:post) { FactoryBot.create(:post) }
    let(:comment) { user.comments.build(getter_id: post.id,
                                          content: "foobar") }

    it "is valid with test data" do
      expect(comment).to be_valid
    end

    describe "presence" do
      it "is invalid without sender_id" do
        comment.sender_id = nil
        expect(comment).to be_invalid
      end

      it "is invalid without getter_id" do
        comment.getter_id = nil
        expect(comment).to be_invalid
      end

      it "is invalid without content" do
        comment.content = nil
        expect(comment).to be_invalid
      end
    end
  end
end
