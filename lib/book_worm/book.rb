module BookWorm

  # == Book
  #
  # Book is used to store the xml data that is returned from ISBNDB
  class Book
    attr_accessor :publisher, :authors, :isbn,
                  :isbn13, :title, :long_title,
                  :book_id, :average_price

    def initialize(book_data)
      self.long_title    = book_data["TitleLong"]
      self.publisher     = book_data["PublisherText"]
      self.authors       = book_data["AuthorsText"].chop.chop
      self.isbn          = book_data["isbn"]
      self.isbn13        = book_data["isbn13"]
      self.title         = book_data["Title"]
      self.book_id       = book_data["book_id"]
      self.average_price = average_price_listed(book_data["Prices"]['Price'])
    end

    private

    def average_price_listed(listings)
      sum = 0.00
      return sum if listings.empty?
      listings.each do |listing|
        sum += listing["price"].to_f
      end
      (sum / listings.size).round(2)
    end
  end
end
