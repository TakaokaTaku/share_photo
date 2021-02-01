RSpec.describe ApplicationHelper, type: :helper do
  describe "full_title" do
    context 'title is foobar' do
      it 'displays full title' do
        expect(full_title('foobar')).to eq("foobar | SharePhoto")
      end
    end

    context 'title is empty' do
      it 'displays base title only' do
        expect(full_title('')).to eq("SharePhoto")
      end
    end
  end
end
