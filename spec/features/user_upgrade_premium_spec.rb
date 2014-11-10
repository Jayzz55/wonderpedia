require 'rails_helper'

feature 'Upgrade to premium', focus: true do
  scenario "users can upgrade to premium" do
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

    #Click link to upgrade membership
    click_link 'Upgrade membership'

    #Click pay now button
    click_button 'Pay with Card'

    #fill in details
    fill_in 'Email', with: user1.email
    fill_in 'Card number', with: 4242424242424242

    #check that user has been upgraded to premium
    expect(page).to have_content("Premium user")

  end
end
