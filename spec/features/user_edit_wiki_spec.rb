require 'rails_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'Editing wiki' do
  scenario "users can edit their own wiki" do
    #create user1 to sign in
    user1 = create(:user)
    login_as(user1, :scope => :user)
    visit wikis_path

    #click new wiki
    click_link "Create new wiki"

    #fill in title and body of the wiki
    fill_in 'title', with: "Hello world"
    fill_in 'wiki', with: "Welcome to my world"

    #click create button
    click_button 'Save'

    #check that the wiki has been created
    expect(page).to have_content("Wiki successfully created.")

    #check that user can see the created wiki
    expect(page).to have_content("Hello world")

    #click delete button to edit wiki
    click_link 'Edit'
    find_field('wiki').should have_content("Welcome to my world")

    #edit and update the wiki
    fill_in('wiki', :with => "Where are we in here?")
    click_button 'Save'

    #check that user can see the updated wiki
    click_link "Hello world"
    expect(page).to have_content("Where are we in here?")
  end

  scenario "users cannot edit or delete other user's wiki" do

    #create user1 to sign in
    user1 = create(:user)
    login_as(user1, :scope => :user)
    visit wikis_path

    #click new wiki
    click_link "Create new wiki"

    #fill in title and body of the wiki
    fill_in 'title', with: "Hello world"
    fill_in 'wiki', with: "Welcome to my world"

    #click create button
    click_button 'Save'

    #check that the wiki has been created
    expect(page).to have_content("Wiki successfully created.")

    #click sign out button
    within '.user-info' do
        click_link 'Sign out'
    end

    #create second user to sign in
    user2 = create(:user)
    login_as(user2, :scope => :user)
    visit wikis_path

    #check second user can see wiki created by first user
    expect(page).to have_content("Hello world")

    #user2 don't have access to edit wiki
    expect(page).not_to have_link("Edit")

    #user2 don't have access to delete wiki
    expect(page).not_to have_link("Delete")

  end
end
