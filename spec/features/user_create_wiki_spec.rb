require 'rails_helper'

feature 'Create wiki pages using Markdown syntax' do
  scenario "lets user create a wiki" do
    #Go to home page
    user = create(:user)
    visit root_path

    #Click sign in link
    within '.user-info' do
      click_link 'Sign In'
    end

    #fill in details
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    #click sign in button
    click_button 'Log in'
    
    #check that user has been signed in
    expect(page).to have_content("Signed in successfully.")

    #click new wiki
    expect(current_path).to eq(wikis_path)
    click_link "Create new wiki"

    #fill in title and body of the wiki
    fill_in 'title', with: "Hello world"
    fill_in 'wiki', with: "Welcome to my world"

    #click create button
    click_button 'Save'

    #check that the wiki has been created
    expect(page).to have_content("Wiki successfully created.")

  end

  scenario "lets user create public wikis that anyone may view" do
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

    #check the content of the wiki
    click_link 'Hello world'
    expect(page).to have_content("Welcome to my world")

  end
end


