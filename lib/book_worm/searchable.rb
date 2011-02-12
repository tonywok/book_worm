module BookWorm
  require 'book_worm/book'
  require 'httparty'

  include HTTParty
  format :xml
  base_uri 'http://isbndb.com'

  module Searchable

    INDICES = [:isbn, :title, :combined, :full]

    INDICES.each do |index|
      index_name = (index.to_s =~ /full|combined/ ? "#{index}_index" : index)

      define_method "find_by_#{index_name}" do |arg|
        find(index, arg)
      end

      define_method "find_all_by_#{index_name}" do |arg|
        find_all(index, arg)
      end
    end

    def find(*args)
      if args.size == 1
        index = :isbn
        value = args[0]
      else
        index = INDICES.include?(args[0]) ? args[0] : :isbn
        value = args[1]
      end
      normalize(query_isbndb(index, value))[0]
    end

    def find_all(*args)
      if args.size == 1
        index = :full
        value = args[0]
      else
        index = INDICES.include?(args[0]) ? args[0] : :full
        value = args[1]
      end
      normalize(query_isbndb(index, value))
    end

    private

    def query_base
      "/api/books.xml"
    end

    def query_isbndb(index, value)
      get(query_base, :query => { :index1 => index,
                                  :value1 => value,
                                  :access_key => Configuration.config[:api_key], })
    end

    def normalize(results)
      begin
        [results['ISBNdb']['BookList']['BookData']].flatten.collect do |book|
          Book.new(book)
        end
      rescue
        []
      end
    end
  end
end
