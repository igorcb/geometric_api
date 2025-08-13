source "https://rubygems.org"

ruby "3.3.4"

gem "rails", "~> 7.1.3"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "rack-cors"
gem 'rswag-api'
gem 'rswag-ui'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "byebug"
  gem 'rspec-rails', '~> 7.1'
  gem 'rswag-specs'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
