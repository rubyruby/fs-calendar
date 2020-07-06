require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

require 'database_cleaner'
require 'capybara/rails'
require 'capybara-screenshot/rspec'
require 'selenium/webdriver'
require 'webdrivers/chromedriver'
require 'devise'


begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Capybara.register_driver :selenium_chrome_headless do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless'
  browser_options.args << '--disable-gpu'
  browser_options.args << '--window-size=1920,1080'
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end
Capybara.javascript_driver = :selenium_chrome_headless

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|

  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.around(:each) do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.include FactoryBot::Syntax::Methods
  config.include Warden::Test::Helpers
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.before(:suite) do
    Warden.test_mode!
  end

  config.after(:each) do
    Warden.test_reset!
  end

end
