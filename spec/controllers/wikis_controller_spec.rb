require 'rails_helper'

RSpec.describe WikisController, :type => :controller do
  describe "GET show" ,focus: true do
    it "returns http success" do
      user = create(:user)
      sign_in user
      wiki = Wiki.create(title: "test one", body: "hello world")
      get :show, {id: Wiki.friendly.find("test-one").id}
      expect(response).to have_http_status(:success)
    end

    it "puts wiki into the view" do
      user = create(:user)
      wiki = Wiki.create(title: "test one", body: "hello world")
      sign_in user
      get :show, {id: Wiki.friendly.find("test-one").id}
      expect(assigns(:wiki)).to eq(wiki)
    end
  end
end