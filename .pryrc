begin
  require 'awesome_print'
  Pry.config.print = proc { |output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output) }
rescue LoadError => err
  puts "no gem awesome_print"
end

if defined?( Rails )
  app_name = File.basename( Rails.root )
  env = Rails.env == 'production' ? Rails.env.upcase : Rails.env
  Pry.config.prompt = proc { | obj, nest_level, _ | "[#{ app_name }][#{ env }] #{obj}:#{ nest_level }> " }
end

puts ''
