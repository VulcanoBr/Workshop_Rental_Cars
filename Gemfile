source "https://rubygems.org"

ruby "3.2.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.2"

gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "redis", ">= 4.0.1"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

# do projeto original
gem "bootstrap", "~> 4.3.1"
gem "delayed_job_active_record"
gem "devise", ">= 4.9.2"
gem "draper"
gem "image_processing", ">=1.2"
gem 'jquery-rails'
gem "sass-rails", ">= 6.0"
gem "securerandom"
gem 'uglifier', '>= 4.2'

# gem "kredis"
# gem "bcrypt", "~> 3.1.7"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
  gem "faker"
  gem "rspec-rails", ">= 6.1"
  gem "dotenv-rails"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  gem "rubocop", ">= 1.59.0", require: false
  gem "rubocop-rails"
  gem "spring-watcher-listen", ">= 2.1.0"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  gem "capybara"
  gem "fuubar"
  gem "factory_bot_rails"
  gem "simplecov", require: false
end

