require 'rails_helper'


describe 'Signing process' do

  it "lets user sign up" do
    # Go to home page
    visit root_path

    # Click the sign up button/link
    within '.user-info' do
      click_link 'Sign Up'
    end

    #fill in the sign up information
    fill_in 'Name', with: "John Smith"
    fill_in 'Email', with: "john_smith@example.com"
    fill_in 'Password', with: "helloworld"
    fill_in 'Password confirmation', with: "helloworld"

    #Click sign up button
    click_button 'Sign up'

    #Check email confirmation
    expect(page).to have_content("A message with a confirmation link has been sent to your email address.")

    #click email confirmation link
    expect(unread_emails_for("john_smith@example.com").count).to eq(1)
    open_email("john_smith@example.com")
    click_email_link_matching(/#{user_confirmation_path}/)

    #see the flash message for sign up confirmation
    expect(page).to have_content("Your email address has been successfully confirmed.")

    #try to sign in
    within '.user-info' do
      click_link 'Sign In'
    end

    #fill in details
    fill_in 'Email', with: "john_smith@example.com"
    fill_in 'Password', with: "helloworld"

    #click sign in button
    click_button 'Log in'
      
    #check that user has been signed in
    expect(page).to have_content("Signed in successfully.")
    
 end

  it "lets user sign in and sign out" do
  
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
    
    #click sign out button
    within '.user-info' do
      click_link 'Sign out'
    end
    
    # check that user has been signed out
    expect(page).to have_content("Signed out successfully.")

  end
end

