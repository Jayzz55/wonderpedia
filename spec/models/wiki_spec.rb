require 'rails_helper'

describe Wiki do
  describe "scopes" do
    before do 
      @user1 = create(:user, premium: true)
      @user2 = create(:user) 
      @private_wiki1 = @user1.wikis.create(:private => true)
      @public_wiki1 = @user2.wikis.create(:private => false)
      @private_wiki2 = @user2.wikis.create(:private => true)
      Collaborator.create(wiki_id: @private_wiki2.id, user_id: @user1.id)
    end

    describe "vieable(user)" do
      it "returns public wiki and all private wikis related to a user" do
        expect(Wiki.viewable(@user1)).to eq( [@private_wiki2, @private_wiki1, @public_wiki1] )
        expect(Wiki.viewable(@user2)).to eq( [@private_wiki2, @public_wiki1] )
      end
    end
  end
end

