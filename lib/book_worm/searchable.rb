require 'httparty'
require 'net/http'

module BookWorm
  class Searchable
    include HTTParty
    format :xml
    base_uri 'http://isbndb.com'

    def self.query_base 
      "/api/#{self.to_s.gsub(/^\w+::/, '').downcase << 's'}.xml"
    end
  end
end


