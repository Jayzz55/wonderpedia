require 'rails_helper'

describe User do
  context "association" do
    it {should have_many(:wikis).through(:collaborators)}
    it {should have_many(:collaborators)}
  end

  describe "user_status" do
    it "returns the status of a user" do
      user1 = create(:user, premium: true)
      user2 = create(:user)
      expect(user1.user_status).to eq("Premium user")
      expect(user2.user_status).to eq("Regular user")
    end
  end
end