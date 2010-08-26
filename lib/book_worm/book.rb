require 'cgi'

module BookWorm
  class Book < Searchable

    INDICES = [:isbn, :title, :combined, :full]

    attr_accessor :publisher, :authors, :isbn,
                  :isbn13, :title, :long_title,
                  :book_id

    def initialize(book_data)
      self.long_title    = book_data["TitleLong"]
      self.publisher     = book_data["PublisherText"]
      self.authors       = book_data["AuthorsText"]
      self.isbn          = book_data["isbn"]
      self.isbn13        = book_data["isbn13"]
      self.title         = book_data["Title"]
      self.book_id       = book_data["book_id"]
    end

    class << self

      INDICES.each do |index|
        index_name = (index.to_s =~ /full|combined/ ? "#{index}_index" : index)

        define_method "find_by_#{index_name}" do |arg|
          find(index, arg)
        end

        define_method "find_all_by_#{index_name}" do |arg|
          find_all(index, arg)
        end
      end

      # possible index/value pairs:
      #   isbn     - pass in a valid isbn or isbn13 value.
      #   title    - keyword search on title, long title and latinized title.
      #   combined - search across titles, authors, and publisher name
      #   full     - search across itles, authors, publisher name, summary,
      #              notes, awards information, etc
      def find(index, value)
        normalize(query_isbndb(index, value))[0]
      end

      def find_all(index, value)
        normalize(query_isbndb(index, value))
      end

      private

      def normalize(results)
        begin
          [results['ISBNdb']['BookList']['BookData']].flatten.collect do |book|
            Book.new(book)
          end
        rescue
          []
        end
      end

      def query_isbndb(index, value)
        get(query_base, :query => { :index1 => index, 
                                    :value1 => value, 
                                    :access_key => "2I9YKZ6J"})
      end

    end
  end
end

