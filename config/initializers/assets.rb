# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

#Rails.application.config.assets.precompile << /\.(?:svg|eot|woff|ttf)\z/

Rails.application.config.assets.precompile << [ '*.svg', '*.eot', '*.woff', '*.ttf' ]

Rails.application.config.assets.precompile << [ '*.png' ]

Rails.application.config.assets.precompile << [ '*.js', '*.css' ]

Rails.application.config.assets.gzip = false

