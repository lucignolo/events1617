source 'https://rubygems.org'

gem 'rails',                   '5.0.1'
gem 'bcrypt',                  '3.1.11'
gem 'faker',                   '1.6.6'
gem 'carrierwave',             '0.11.2'
gem 'mini_magick',             '4.5.1'
gem 'fog',                     '1.38.0'
##gem 'will_paginate',           '3.1.0'
## Gemfile for Rails 3+, Sinatra, or Merb
#gem 'will_paginate', '~> 3.1.1'
#gem 'bootstrap-will_paginate', '0.0.10'
gem 'bootstrap-sass',          '3.3.6'
gem 'puma',                    '3.4.0'
gem 'sass-rails',              '5.0.6'
gem 'uglifier',                '3.0.0'
gem 'coffee-rails',            '4.2.1'
gem 'jquery-rails',            '4.1.1'
gem 'jquery-ui-rails'
gem 'turbolinks',              '5.0.1'
gem 'jbuilder',                '2.4.1'

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '3.1.2'
#gem 'bcrypt-ruby', '~> 3.1.2'

group :development, :test do
  gem 'sqlite3', '1.3.12'
  gem 'byebug',  '9.0.0', platform: :mri
end

group :development do
  gem 'web-console',           '3.1.1'
  gem 'listen',                '3.0.8'
  gem 'spring',                '1.7.2'
  gem 'spring-watcher-listen', '2.0.0'
end

#group :test do: il 21/09/2017 sostituisco questo group con il successivo
#  gem 'rails-controller-testing', '0.1.1'
#  gem 'minitest-reporters',       '1.1.9'
#  gem 'guard',                    '2.13.0'
#  gem 'guard-minitest',           '2.4.4'
#end

group :test do
  gem 'rails-controller-testing', '0.1.1'
  gem 'minitest-reporters',       '1.1.9'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
  gem "minitest",                 '5.10.1'
end

group :production do
  gem 'pg',   '0.18.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# aggiunta in Windows per server
gem 'wdm', '>= 0.1.0' if Gem.win_platform?

# per scaricare la gem 'kaminari' per la pagination 01/07/2016
gem 'kaminari'  