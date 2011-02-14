module BookWorm
  require 'book_worm/book'
  require 'httparty'

  include HTTParty
  format :xml
  base_uri 'http://isbndb.com'

  # == Searchable
  #
  # A module that implements the basic finder methods for accessing the ISBNdb API
  #
  module Searchable

    # == Searchable indices
    #
    # These indices represent the BookWorm supported searching methods
    #
    INDICES = [:isbn, :title, :combined, :full]

    # Define convenience methods for #find and #find_all.
    #
    # == Example Usage
    #
    # BookWorm.find_by_isbn("1234567890")
    # BookWorm.find_by_title("Programming Ruby")
    # BookWorm.find_by_combined_index("Programming Ruby")
    # BookWorm.find_by_full_index("Programming Ruby")
    #
    # BookWorm.find_all_by_isbn("1234567890")
    # BookWorm.find_all_by_title("Programming Ruby")
    # BookWorm.find_all_by_combined_index("Programming Ruby")
    # BookWorm.find_all_by_full_index("Programming Ruby")
    #
    INDICES.each do |index|
      index_name = (index.to_s =~ /full|combined/ ? "#{index}_index" : index)

      define_method "find_by_#{index_name}" do |arg|
        find(index, arg)
      end

      define_method "find_all_by_#{index_name}" do |arg|
        find_all(index, arg)
      end
    end

    # Given a valid index and a value, this method returns the first match found
    # after querying ISBNdb. The default index, :isbn, will be used
    # in the event that you only supply one argument
    #
    # == Example Usage
    #
    # Query ISBNdb with an isbn-10
    #   BookWorm.find(:isbn, "1234567890")
    #   BookWorm.find("1234567890")
    #
    # Query ISBNdb with an isbn-13
    #   BookWorm.find(:isbn, "1234567890123")
    #   BookWorm.find("1234567890123")
    #
    # Query ISBNdb with a title
    #   BookWorm.find(:title, "Programming Ruby")
    #
    # Query ISBNdb with a combined index. Search index that combines titles, authors, and
    # publisher name.
    #   BookWorm.find(:combined, "Programming Ruby")
    #
    # Query ISBNdb with a full index. A full index includes titles, authors, publisher
    # name, summary, notes, awards information, etc -- practically every bit of textual
    # information ISBNdb.com has about books.
    #   BookWorm.find(:full, "Programming Ruby")
    #
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

    # Given a valid index and a value, this method returns the all matches found
    # after querying ISBNdb. The default index, :full, will be used
    # in the event that you only supply one argument
    #
    # == Example Usage
    #
    # Query ISBNdb with an isbn-10
    #   BookWorm.find_all(:isbn, "1234567890")
    #
    # Query ISBNdb with an isbn-13
    #   BookWorm.find_all(:isbn, "1234567890123")
    #
    # Query ISBNdb with a title
    #   BookWorm.find_all(:title, "Programming Ruby")
    #
    # Query ISBNdb with a combined index. Search index that combines titles, authors, and
    # publisher name.
    #   BookWorm.find_all(:combined, "Programming Ruby")
    #
    # Query ISBNdb with a full index. A full index includes titles, authors, publisher
    # name, summary, notes, awards information, etc -- practically every bit of textual
    # information ISBNdb.com has about books.
    #   BookWorm.find_all(:full, "Programming Ruby")
    #   BookWorm.find("Programming Ruby")
    #
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

    # :nodoc:
    def query_base
      "/api/books.xml"
    end

    # :nodoc:
    def query_isbndb(index, value)
      get(query_base, :query => { :index1 => index,
                                  :value1 => value,
                                  :access_key => Configuration.config[:api_key], })
    end

    # :nodoc:
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
