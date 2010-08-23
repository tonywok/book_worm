require 'spec_helper'
require 'lib/book_worm'

describe BookWorm do
  context "When querying for a single book," do
    context "and the index is explicitly known," do 

      it "should find by isbn." do
        result = BookWorm::Book.find_book(:isbn, "1934356085")
        
        result.isbn.should == "1934356085"
      end

      it "should find by title." do
        result = BookWorm::Book.find_book(:title, "Programming Ruby 1.9")
        result.title.should == "Programming Ruby 1.9"
      end

      it "should find by titles, authors, and publisher name" do
        result = BookWorm::Book.find_book(:combined, "Ruby Thomas Pragmatic")
        result.title.should =~ /ruby|rails/i
      end

      it "should find by practically all information ISBNdb.com has about books." do
        result = BookWorm::Book.find_book(:full, "pragmatic ruby rails thomas")
        result.title.should =~ /ruby|rails/i
      end
    end

    #   it "should search with the publisher_id index" do
    #     ruby_book = BookWorm::Book.search(:publisher_id, "978-1934356081")
    #     ruby_book.isbn.should == "978-1934356081"
    #   end

    #   it "should search with the subject_id index" do
    #     ruby_book = BookWorm::Book.search(:subject_id, "978-1934356081")
    #     ruby_book.isbn.should == "978-1934356081"
    #   end

    #   it "should search with the icc_number index" do
    #     ruby_book = BookWorm::Book.search(:icc_number, "978-1934356081")
    #     ruby_book.isbn.should == "978-1934356081"
    #   end

    #   it "should search with the dewey_decimal index" do
    #     ruby_book = BookWorm::Book.search(:dewey_decimal, "978-1934356081")
    #     ruby_book.isbn.should == "978-1934356081"
    #   end
    # end

    # it "should be able to 'search by isbn'" do
    #   ruby_book = BookWorm::Book.search_by_isbn("1934356085")
    #   ruby_book.isbn.should == "1934356085"
    # end

    # it "should be able to search by title" do
    #   results = BookWorm::Book.search(:title, 'Ruby')
    #   results.each do |book|
    #     return true if book.title == "Programming Ruby 1.9"
    #   end.should be_true
    # end
  end
end

