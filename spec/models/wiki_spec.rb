require 'rails_helper'

describe Wiki do
  context "association" do
    it {should have_many(:users).through(:collaborators)}
    it {should have_many(:collaborators)}
  end

  context "validation" do
    it {should validate_presence_of(:title)}
    it {should validate_presence_of(:body)}
    it {should ensure_length_of(:title).is_at_least (5)}
    it {should ensure_length_of(:body).is_at_least (5)}
  end

  before do
    @user1 = create(:user, premium: true)
    @user2 = create(:user) 
    @private_wiki1 = create(:wiki_with_user, title:"Hello world", body:"welcome to my world", :private => true, user: @user1)
    @public_wiki1 = create(:wiki_with_user, title:"Hello public", body:"This is public space", :private => false, user: @user2)
    @private_wiki2 = create(:wiki_with_user, title:"Another private wiki", body:"This is private space", :private => true, user: @user2)  
  end

  describe "viewable(user)" do
    it "returns public wiki and all private wikis related to a user" do
      Collaborator.create(wiki_id: @private_wiki2.id, user_id: @user1.id)
      expect(Wiki.viewable(@user1)).to eq( [@private_wiki2, @public_wiki1, @private_wiki1 ] )
      expect(Wiki.viewable(@user2)).to eq( [@private_wiki2, @public_wiki1] )
    end
  end


  describe "premium_access?" do
    it "validate that the private wiki can only be accessed by the creator with premium role" do
      expect(@private_wiki1.premium_access?(@user1)).to eq(true)
    end
  end

  describe "is_creator?" do
    it "checks if the user is the creator of the wiki" do
      expect(@private_wiki2.users.first).to eq(@user2)
    end
  end

  describe "check_user_exist?" do
    it "check that the user is included in wiki.users" do
      Collaborator.create(wiki_id: @private_wiki2.id, user_id: @user1.id)
      expect(@private_wiki2.check_user_exist?(@user1)).to eq(true)
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

  describe "default scope" do
    it 'should be correctly ordered in descending order' do
      wikis = []
      wikis << @private_wiki1
      wikis << @public_wiki1 
      wikis << @private_wiki2
      sorted_wikis = Wiki.all

      expect(wikis.first).to be == sorted_wikis.last
      expect(wikis.second).to be == sorted_wikis.second
      expect(wikis.last).to be == sorted_wikis.first
    end
  end
end

