require 'rails_helper'

describe Wiki do
  before do
    @user1 = create(:user, premium: true)
    @user2 = create(:user) 
    @private_wiki1 = @user1.wikis.create(title:"Hello world", body:"welcome to my world", :private => true)
    @public_wiki1 = @user2.wikis.create(title:"Hello world", body:"welcome to my world", :private => false)
    @private_wiki2 = @user2.wikis.create(title:"Hello world", body:"welcome to my world", :private => true)  
  end

  describe "viewable(user)" do
    it "returns public wiki and all private wikis related to a user" do
      Collaborator.create(wiki_id: @private_wiki2.id, user_id: @user1.id)
      expect(Wiki.viewable(@user1)).to eq( [@private_wiki2, @private_wiki1, @public_wiki1] )
      expect(Wiki.viewable(@user2)).to eq( [@private_wiki2, @public_wiki1] )
    end
  end


  describe "premium_access?" do
    it "validate that the private wiki can only be accessed by the creator with premium role" do
      expect(@private_wiki1.premium_access?(@user1)).to eq(true)
    end
  end

  describe "check_exist?" do
    it "check that the user is included in wiki.users" do
      Collaborator.create(wiki_id: @private_wiki2.id, user_id: @user1.id)
      expect(@private_wiki2.check_exist?(@user1)).to eq(true)
    end
  end

  describe "collaborators_name" do
    it "returns the name of all collaborators authorzied in a wiki" do
      Collaborator.create(wiki_id: @private_wiki2.id, user_id: @user1.id)
      expect(@private_wiki2.collaborators_name).to eq("#{@user2.name},#{@user1.name}")
    end
  end

  describe "update_collaboration" do
    it "returns the parameter of user ids in which new collaborator relationship to be created" do
    captured_params = ["#{@user2.id}"]
    expect(@private_wiki1.update_collaboration(captured_params,@user1)).to eq([@user2.id])
    end
  end
end

