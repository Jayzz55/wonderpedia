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
    expect(page).to have_no_content("Premium user")
    within '.user-info' do
      click_link 'Upgrade membership'
    end
    
    #Click pay now button
    find_button('Pay with Card').click()

    Capybara.within_frame 'stripe_checkout_app'do
    find 'body' # Waits for iframe body to load.
    end

    #fill in details
    Capybara.within_frame 'stripe_checkout_app' do
      fill_in 'Email', with: user1.email
      fill_in "Card number", with: "4242424242424242"
      fill_in 'CVC', with: '123'
      fill_in 'MM / YY', with: '11/14'

      click_button 'Pay $5.00'
    end

    #Check that user has paid and upgraded to premium
    Capybara.using_wait_time(20) do
      expect(page).to have_content("Thanks for all the money, #{user1.email}! Feel free to pay me again.")
      expect(page).to have_content("Premium user")
    end

  end

  scenario "test that stripe javascript implementation is correct" do

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
    expect(page).to have_no_content("Premium user")
    within '.user-info' do
      click_link 'Upgrade membership'
    end
    
    #Click pay now button
    find_button('Pay with Card').click()

    # Note the `visible: false` option for including elements in the find search
    # that aren't displayed as something visible in the page.
    stripe_script_element = find('script.stripe-button', visible: false)
    expect(stripe_script_element[:src]).to eq "https://checkout.stripe.com/checkout.js" 
    expect(stripe_script_element[:"data-amount"]).to eq "500"
    expect(stripe_script_element[:"data-description"]).to eq "Wonderpedia Premium Membership - #{user1.name}"
  end
end
