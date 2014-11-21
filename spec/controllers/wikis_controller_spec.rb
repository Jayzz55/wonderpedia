require 'rails_helper'

RSpec.describe WikisController, :type => :controller do

  describe "GET show" do
    before do
      user = create(:user)
      sign_in user
      @wiki = Wiki.create(title: "test one", body: "hello world")
      get :show, {id: "test-one"}
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "puts wiki into the view" do
      expect(assigns(:wiki)).to eq(@wiki)
    end

    it "renders the show template" do
      expect(response).to render_template("show")
    end
  end

  describe "GET index" do
    before do
      @user = create(:user)
      sign_in @user
      @wiki1 = Wiki.create(title: "test one", body: "hello world")
      @wiki2 = Wiki.create(title: "test two", body: "hello world again")
    end

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "puts all wiki into the view" do
      get :index
      expect(assigns(:wikis)).to eq(Wiki.viewable(@user))
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "POST create" do
    before do
      @user = create(:user)
      sign_in @user
    end

    context "valid wiki"
      it "creates a new wiki" do
        wiki_params = {wiki: {title:"test one", body:"hello world"}}
        post :create, wiki_params
        expect(Wiki.count).to eq(1)
      end

      it "redirects to wikis index" do
        wiki_params = {wiki: {title:"test one", body:"hello world"}}
        post :create, wiki_params
        expect(response).to redirect_to wikis_path
      end

    context "invalid wiki" do
      it "does not create invalid wiki" do
        wiki_params = {wiki: {title: "", body:"hello world"}}
        post :create, wiki_params
        expect(Wiki.count).to eq(0)
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @user = create(:user)
      @user.wikis.create(title: "test one", body: "hello world")
      sign_in @user
    end

    it "raise exception for deleting unknown id" do
      expect { delete :destroy, { id: '' } }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "deletes the wiki" do
      delete :destroy, {id: "test-one"}
      expect(Wiki.count).to eq(0)
    end

    it "cannot delete other user's wiki" do
      other_user = create(:user)
      other_user.wikis.create(title: "test two", body: "hello world again")
      delete :destroy, {id: "test-two"}
      expect(Wiki.count).to eq(2)
    end
    
    it "redirects to wikis index" do
      delete :destroy, {id: "test-one"} 
      expect(response).to redirect_to wikis_path
    end
  end

  describe "PUT update", focus: true do
    before do
      user = create(:user)
      sign_in user 
      Wiki.create(title: "test one", body: "hello world")
      @wiki1 = Wiki.first
    end

    context "valid update" do
      it "located the requested @wiki" do
        put :update, {id: "test-one"}
        
      end

      it "changes @wiki's attributes" do

      end

      it "redirects to the updated contact" do

      end
    end

    context "invalid update" do
      it "located the requested @wiki" do
        
      end

      it "does not changes @wiki's attributes" do

      end

      it "re-renders the edit method" do

      end
    end
  end
end