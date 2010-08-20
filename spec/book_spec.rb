require 'spec_helper'
require 'lib/book_worm'

describe BookWorm do
  context "When querying for a book." do

    it "should be able to search explicitly by isbn" do
      ruby_book = BookWorm::Book.search(:isbn, "1934356085")
      ruby_book.isbn.should == "1934356085"
    end

    it "should be able to 'search by isbn'" do
      ruby_book = BookWorm::Book.search_by_isbn("1934356085")
      ruby_book.isbn.should == "1934356085"
    end

    it "should be able to search by title" do
      results = BookWorm::Book.search(:title, 'Ruby')
      results.each do |book|
        return true if book.title == "Programming Ruby 1.9"
      end.should be_true
    end
  end
end

