source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'


gem 'rails', '~> 6.0.3', '>= 6.0.3.1'

gem 'pg', '>= 0.18', '< 2.0'

gem 'puma', '~> 4.1'

gem 'webpacker', '~> 4.0'

gem 'bootsnap', '>= 1.4.2', require: false

gem 'slim-rails'

gem 'devise'

gem 'enumerize'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 4.0.0'
  gem 'ffaker'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'annotate'
end

group :test do
  gem 'database_cleaner'
  gem 'simplecov', require: false
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'selenium-webdriver'
  gem 'webdrivers', '~> 4.0'
end
