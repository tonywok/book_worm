require 'rspec'
require 'book_worm'

BookWorm::Configuration.configure do |c|
  c[:api_key] = "Your API key"
end

