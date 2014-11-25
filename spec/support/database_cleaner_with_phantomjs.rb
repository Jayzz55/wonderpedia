RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each, js: true) do
    # For JavaScript tests ensure we're not using transactions as they're
    # not shared into the phantomjs thread.
    # http://www.railsonmaui.com/tips/rails/capybara-phantomjs-poltergeist-rspec-rails-tips.html
    # http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/
    DatabaseCleaner[:active_record].strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
    Warden.test_mode!
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Warden.test_reset!
  end
  
end