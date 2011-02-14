module BookWorm

  # == Configuration
  #
  # Module for storing configuration settings
  module Configuration
    extend self

    attr_accessor :config
    @config = {}

    # Provides a method client to specify their ISBNDB API key.
    #
    # == Example
    #
    # BookWorm::Configuration.configure do |c|
    #   c[:api_key] = YOUR_ISBNDB_API_KEY
    # end
    def configure
      yield @config
    end
  end
end
