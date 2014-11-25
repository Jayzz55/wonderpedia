require 'rails_helper'

RSpec.describe CollaboratorsController, :type => :controller, focus: true do

  describe "GET index" do
    before do
      user1 = create(:user, premium: true)
      @user2 = create(:user)
      @user3 = create(:user)
      wiki_user1 = create(:wiki_with_user, user: user1)
      sign_in user1
    end

    it "returns http success" do
      get :index, {wiki_id: "test-one"}
      expect(response).to have_http_status(:success)
    end

    it "puts collaborators into view excluding the signed-in user" do
      get :index, {wiki_id: "test-one"}
      expect(assigns(:user)).to eq([@user2, @user3])
    end

    it "renders the index template" do
      get :index, {wiki_id: "test-one"}
      expect(response).to render_template("index")
    end
  end

  describe "PUT update_multiple" do
    before do
      @user1 = create(:user, premium: true)
      @user2 = create(:user)
      @user3 = create(:user)
      @wiki_user1 = create(:wiki_with_user, user: @user1)
      Collaborator.create(wiki_id: @wiki_user1.id, user_id: @user2.id)
      sign_in @user1
    end

    context "valid update" do
      before do
        expect(Wiki.first.users).to eq([@user1, @user2]) #check that user1 and user2 is in collaborators list
        put :update_multiple, {wiki_id: "test-one", users: [@user3.id]}
      end

      it "update_multiple collaborators relationship - delete user2 and add user3" do
        expect(Wiki.first.users).to eq([@user1, @user3])
      end

      it "redirects to the collaborators index page" do
        expect(response).to redirect_to wiki_collaborators_path(@wiki_user1)
      end
    end

    context "attacker attempt to add himself into collaborator list" do
      it "prevent an attacker update collaborators" do
        attacker = @user3
        sign_out @user1
        sign_in attacker
        put :update_multiple, wiki_id: "test-one", users: [attacker.id]
        expect(Wiki.first.users).to eq([@user1, @user2])
      end
    end
  end
end