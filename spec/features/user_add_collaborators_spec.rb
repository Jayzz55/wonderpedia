require 'rails_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'Add collaborators', focus: true do
  scenario "users can add collaborators on a wiki" do
    #create user1 to sign in
    user1 = create(:user)
    login_as(user1, :scope => :user)
    visit wikis_path

    #create a new wiki and access the wiki
    click_link "Create new wiki"
    fill_in 'title', with: "Hello world"
    fill_in 'wiki', with: "Welcome to my world"
    click_button 'Save'
    click_link "Hello world"


  end
end