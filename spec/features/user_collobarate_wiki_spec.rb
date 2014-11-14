require 'rails_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'Users collaborate on wiki' do
  scenario "authorized users can colloborate on wiki" do

    #create user1 as premium, and user2 as normal user
    user1 = create(:user, premium: true)
    user2 = create(:user, premium: true)
    user3 = create(:user)

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

    #add user2 as collaborator
    page.check('user_2')
    page.check('user_3')
    click_button 'Share wiki'

    #check that user2 have been added as collaborators
    expect(page).to have_content("Collaborators successfully updated.")
    expect(page).to have_checked_field("user_2")
    expect(page).to have_checked_field("user_3")

    #user1 logout
    logout(user1)

    #user2 login
    login_as(user2, :scope => :user)
    visit wikis_path

    #user2 can find user1's shared private wiki
    expect(page).to have_content("Hello world")

    #user2 don't have access to add collaborators
    expect(page).not_to have_link("Collaborate")

    #user2 don't have access to delete wiki
    expect(page).not_to have_link("Delete")

    #user2 collaborate on the shared wiki
    click_link "Edit"
    fill_in('title', :with => "I love foods!")
    fill_in('wiki', :with => "My favourite dish is takoyaki")
    click_button 'Save'

    #check that user2 has updated the shared wiki
    expect(page).to have_no_content("Hello world")
    expect(page).to have_content("I love foods!")

    #user2 logout
    logout(user2)

    #user3 login
    login_as(user3, :scope => :user)
    visit wikis_path

    #user3 can find user1's shared private wiki
    expect(page).to have_content("I love foods!")

    #user3 don't have access to add collaborators
    expect(page).not_to have_link("Collaborate")

    #user3 don't have access to delete wiki
    expect(page).not_to have_link("Delete")

    #user3 collaborate on the shared wiki
    click_link "Edit"
    fill_in('title', :with => "My travelling journal")
    fill_in('wiki', :with => "What a lovely night in Rosebery")
    click_button 'Save'

    #check that user3 has updated the shared wiki
    expect(page).to have_no_content("I love foods!")
    expect(page).to have_content("My travelling journal")
  end

  scenario "unauthorized users cannot collaborate on wiki" do
    #create user1 as premium, and user2 as normal user
    user1 = create(:user, premium: true)
    user2 = create(:user, premium: true)
    user3 = create(:user)

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

    #user1 logout
    logout(user1)

    #user2 signing in
    login_as(user2, :scope => :user)
    visit wikis_path

    #user2 cannot find user1's wiki
    expect(page).to have_no_content("Hello world")
    expect(page).not_to have_link("Collaborate")
    expect(page).not_to have_link("Delete")
    expect(page).not_to have_link("Edit")

    #user2 logout
    logout(user2)

    #user3 signing in
    login_as(user3, :scope => :user)
    visit wikis_path

    #user3 cannot find user1's wiki
    expect(page).to have_no_content("Hello world")
    expect(page).not_to have_link("Collaborate")
    expect(page).not_to have_link("Delete")
    expect(page).not_to have_link("Edit")

  end
end