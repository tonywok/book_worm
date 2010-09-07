module BookWorm
  class Book
    include Searchable
    include HTTParty
    format :xml
    base_uri 'http://isbndb.com'

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

  end
end

