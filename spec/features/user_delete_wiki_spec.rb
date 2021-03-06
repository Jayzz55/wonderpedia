require 'rails_helper'

feature 'Deleting wiki' do
  scenario "users can delete their own wiki" do
    #create user to sign in
    user1 = create(:user)
    visit root_path

    #Click sign in link
    within '.user-info' do
      click_link 'Sign In'
    end

    #fill in details
    fill_in 'Email', with: user1.email
    fill_in 'Password', with: user1.password

    #click sign in button
    click_button 'Log in'

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

    #click delete button to delete wiki
    click_link 'Delete'
    expect(page).to have_no_content("Hello world")

  end
  scenario "users cannot delete other user's wiki" do

    #create first user to sign in
    user1 = create(:user)
    visit root_path

    #Click sign in link
    within '.user-info' do
      click_link 'Sign In'
    end

    #fill in details
    fill_in 'Email', with: user1.email
    fill_in 'Password', with: user1.password

    #click sign in button
    click_button 'Log in'

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
    visit root_path
    within '.user-info' do
      click_link 'Sign In'
    end
    fill_in 'Email', with: user2.email
    fill_in 'Password', with: user2.password
    click_button 'Log in'

    #check second user can see wiki created by first user
    expect(page).to have_content("Hello world")

    #check that the create wiki has no delete button
    expect(page).not_to have_link("Delete")

  end
end
