require 'cgi'

module BookWorm
  class Book < Searchable
    
    INDICES = %w[isbn title combined full]

    attr_accessor :publisher, :authors, :isbn,
                  :isbn13, :title, :long_title, 
                  :book_id

    def initialize(book_data)
      self.long_title = book_data["TitleLong"]
      self.publisher  = book_data["PublisherText"]
      self.authors    = book_data["AuthorsText"]
      self.isbn       = book_data["isbn"]
      self.isbn13     = book_data["isbn13"]
      self.title      = book_data["Title"]
      self.book_id    = book_data["book_id"]
    end

    class << self

      INDICES.each do |index|
        define_method "search_by_#{index}" do |arg|
          search(index, arg)
        end
      end

      # possible index/value pairs:
      #   isbn     - pass in a valid isbn or isbn13 value.
      #   title    - keyword search on title, long title and latinized title.
      #   combined - search across titles, authors, and publisher name
      #   full     - search across itles, authors, publisher name, summary, 
      #              notes, awards information, etc
      def search(index, value)
        normalize(query_isbndb(index, value))
      end

      private

      def normalize(results)
        books = [results['ISBNdb']['BookList']['BookData']].flatten
        books.size == 1 ? Book.new(books[0]) : books.collect {|book| Book.new(book) }
      end

      def query_isbndb(index, value)
        get(query_base, :query => { :index1 => index, 
                                    :value1 => value, 
                                    :access_key => "2I9YKZ6J"})
      end

    end
  end
end

