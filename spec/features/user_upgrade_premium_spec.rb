require 'rails_helper'

feature 'Upgrade to premium',js: true do
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
    expect(page).to have_content("Signed in successfully.")

    #Click link to upgrade membership
    within '.user-info' do
      click_link 'Upgrade membership'
    end
    
    #Click pay now button
    find_button('Pay with Card').click()
    sleep 30

    #fill in details
    Capybara.within_frame 'stripe_checkout_app' do
      fill_in 'Email', :with => 'persona@example.com'
      fill_in "Card number", :with => "4242424242424242"
      fill_in 'CVC', :with => '123'
      fill_in 'MM / YY', :with => '11/14'

      click_button 'Pay $15.00'
    end
    sleep 60

    #Check that user has paid and upgraded to premium
    expect(page).to have_content("Thanks for all the money")
    expect(page).to have_content("Premium user")

  end
end
