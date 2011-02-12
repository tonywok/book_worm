module BookWorm
  module Configuration
    extend self

    attr_accessor :config
    @config = {}

    def configure
      yield @config
    end
  end
end
