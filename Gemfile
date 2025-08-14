# Replace your Gemfile with this:
source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

gem "rails", "~> 7.1.0"
gem "pg", "~> 1.1"
gem "puma", "~> 6.0"
gem "bootsnap", ">= 1.4.4", require: false
gem "image_processing", "~> 1.2"

# Authentication & Security
gem 'jwt'
gem 'bcrypt', '~> 3.1.7'
gem 'rack-cors'

# Background Jobs
gem 'sidekiq'
gem 'redis', '~> 4.0'

# API Integration
gem 'httparty'
gem 'faraday'

# File Upload (FREE alternative to AWS)
gem 'cloudinary'

gem 'dotenv-rails', groups: [:development, :test]

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'rubocop', require: false
end