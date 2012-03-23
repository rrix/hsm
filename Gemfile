source 'http://rubygems.org'

gem 'hsm_tools',  :path => '../hsm_tools'
gem 'hsm_skills', :path => '../hsm_skills'

gem 'bluecloth'
gem 'cancan'
gem 'devise'
gem 'dynamic_form'
gem 'jquery-rails'
gem 'paperclip', "~> 2.4"
gem 'pg'
gem 'rack-ssl-enforcer'
gem 'rails-settings-cached'
gem 'rails-settings'
gem 'will_paginate', '~> 3.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.2.0"
end

group :development, :test do
  gem 'cover_me', '>= 1.2.0'
  gem 'guard-livereload'
  gem 'guard-rspec'
  gem 'pry'
  gem 'pry-doc'
  gem 'rspec-rails'
end

group :production, :staging do#, :ci do
  gem 'thin'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'shoulda'
end

group :production, :staging do#, :ci do
  gem 'thin'
end

