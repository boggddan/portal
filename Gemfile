source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

gem 'turbolinks', '~> 5'
gem 'bcrypt', git: 'https://github.com/codahale/bcrypt-ruby.git'
gem 'tzinfo-data'

gem 'puma'
gem 'slim'
gem 'pg'
gem 'savon'
gem 'awesome_print'

# it is not work in ruby 2.4. Wait maintain
#gem 'pry-rails'

