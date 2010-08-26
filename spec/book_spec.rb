require 'spec_helper'
require 'lib/book_worm'

describe BookWorm do
  describe '#find_book' do
    context 'when querying for a book by isbn' do
      before :each do
       @book_data = { :isbn       => "1934356085",
                      :isbn13     => "9781934356081",
                      :book_id    => "programming_ruby_1_9",
                      :publisher  => "Pragmatic Bookshelf",
                      :title      => 'Programming Ruby 1.9',
                      :long_title => "Programming Ruby 1.9: The Pragmatic Programmers' Guide",
                      :authors    => "Dave Thomas, Chad Fowler, Andy Hunt, " }
      end
      it 'returns a unique book represented by given isbn' do
        result = BookWorm::Book.find_book(:isbn, @book_data[:isbn])
        @book_data.each do |key,val|
          result.send(key).should == val
        end
      end

      it 'can index on isbn13' do
        result = BookWorm::Book.find_book(:isbn, @book_data[:isbn13])
        @book_data.each do |key,val|
          result.send(key).should == val
        end
      end

      context 'and take advantage of helpers' do
        it 'can index on isbn13' do
          result = BookWorm::Book.find_book_by_isbn(@book_data[:isbn13])
          @book_data.each do |key,val|
            result.send(key).should == val
          end
        end

        it 'can index on isbn13' do
          result = BookWorm::Book.find_book_by_isbn(@book_data[:isbn13])
          @book_data.each do |key,val|
            result.send(key).should == val
          end
        end
      end
    end

    # context '' do
    #   it 'can index on title' do
    #     result = BookWorm::Book.find_book(:title, 'Programming Ruby 1.9')
    #     result.title.should  == 'Programming Ruby 1.9'
    #   end
    #   it 'can do a combined index' do
    #     result = BookWorm::Book.find_book(:combined, 'Ruby Hansson Pragmatic')
    #     result.title.should =~ /rails/i
    #   end

    #   it 'can do a full index' do
    #     text_from_summary = 'Rails makes it both fun and easy to turn out very cool web applications'
    #     result = BookWorm::Book.find_book(:full, "#{text_from_summary} Pragmatic")
    #     result.title.should == 'Agile Web Development with Rails'
    #   end
    # end

    # context 'and taking advantage of helpers,' do
    #   it 'indexes on isbn' do
    #     result = BookWorm::Book.find_book_by_isbn '1934356085'
    #     result.isbn.should  == '1934356085'
    #   end

    #   it 'indexes on title' do 
    #     result = BookWorm::Book.find_book_by_title 'Programming Ruby 1.9'
    #     result.title.should  == 'Programming Ruby 1.9'
    #   end

    #   it 'indexes on combined index' do 
    #     result = BookWorm::Book.find_book_by_combined 'Ruby Hansson Pragmatic'
    #     result.title.should =~ /rails/i
    #   end

    #   it 'can do a full index' do
    #     text_from_summary = 'Rails makes it both fun and easy to turn out very cool web applications'
    #     result = BookWorm::Book.find_book_by_full("#{text_from_summary} Pragmatic")
    #     result.title.should == 'Agile Web Development with Rails'
    #   end
    # end
  end
end
