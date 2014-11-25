require 'rails_helper'

include Warden::Test::Helpers

feature 'Add collaborators' do
  scenario "users can add collaborators on a wiki" do
    #create user1 as premium, and user2,3, and 4 as normal user
    user1 = create(:user, premium: true)
    user2 = create(:user)
    user3 = create(:user)
    user4 = create(:user)

    #Premium user1 signing in
    login_as(user1, :scope => :user)
    visit wikis_path

    #create a new private wiki
    click_link "Create new wiki"
    fill_in 'title', with: "Hello world"
    fill_in 'wiki', with: "Welcome to my world"
    check 'private'
    click_button 'Save'
    expect(current_path).to eq(wikis_path)

    #click link to add collaborators
    click_link "Collaborate"

    #check that users are in collaborator list
    within_table("wiki_collaborator") do
      expect(page).to have_no_content(user1.email)
      expect(page).to have_content(user2.name)
      expect(page).to have_content(user3.name)
      expect(page).to have_content(user4.name)
    end

    #add user2 and user3 as collaborators
    check('user_2')
    check('user_3')
    click_button 'Share wiki'

    #check that user2 and user3 have been added as collaborators
    expect(page).to have_content("Collaborators successfully updated.")
    expect(page).to have_checked_field("user_2")
    expect(page).to have_checked_field("user_3")
    expect(page).not_to have_checked_field("user_4")

  end
end