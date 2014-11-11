require 'rails_helper'

include Warden::Test::Helpers
Warden.test_mode!

feature 'Create private wiki', focus: true do
  scenario "premium users can create private wiki" do
    #create premium user1 to sign in
    user1 = create(:user, premium: true)
    login_as(user1, :scope => :user)
    visit wikis_path

    #check user1 is premium user
    expect(page).to have_content("Premium user")

    #create private wiki
    click_link "Create new wiki"
    fill_in 'title', with: "Hello world"
    fill_in 'wiki', with: "Welcome to my world"
    expect(page).to have_content('private')
    check 'private'
    click_button 'Save'
    expect(page).to have_content("Wiki successfully created.")

    #logout user1
    logout(user1)

    #create premium user2 to sign in
    user2 = create(:user, premium: true)
    login_as(user2, :scope => :user)
    visit wikis_path

    #check user1 is premium user
    expect(page).to have_content("Premium user")

    #create private wiki
    click_link "Create new wiki"
    fill_in 'title', with: "Travelling love"
    fill_in 'wiki', with: "Japan is my favorite"
    expect(page).to have_content('private')
    check 'private'
    click_button 'Save'
    expect(page).to have_content("Wiki successfully created.")

    #check user2 can see his private wiki but not user 1's private wiki
    expect(page).to have_no_content("Hello world")
    expect(page).to have_content("Travelling love")

    #logout user2
    logout(user2)

    #create non-premium user3 to sign in
    user3 = create(:user)
    login_as(user3, :scope => :user)
    visit wikis_path

    #check user3 is not premium user
    expect(page).to have_no_content("Premium user")

    #check user3 can't see private wiki from user1 and user2
    expect(page).to have_no_content("Hello world")
    expect(page).to have_no_content("Travelling love")

  end

  scenario "normal users cannot create private wiki" do
    #create user1 to sign in
    user1 = create(:user)
    login_as(user1, :scope => :user)
    visit wikis_path

    #check user1 is not premium user
    expect(page).to have_no_content("Premium user")

    #check user1 cannot create private wiki
    click_link "Create new wiki"
    expect(page).to have_no_content('private')

  end
end
