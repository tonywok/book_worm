require 'spec_helper'
require 'book_worm'

describe BookWorm do
  describe '#find' do
    context 'when a search results in no matches' do
      it 'returns nil' do
        BookWorm.find(:isbn, 'Jiveturkey').should be_nil
      end
    end

    context 'when finding without a specified index' do
      it 'defaults to an isbn index' do
        BookWorm.find('1934356085').isbn.should == '1934356085'
      end
    end

    context 'when finding with a non-supported index' do
      it 'defaults to an isbn index' do
        BookWorm.should_receive(:query_isbndb).with(:isbn, '1934356085')
        BookWorm.find(:jiveturkey, '1934356085')
      end
    end

    before :each do
     @book_data = { :isbn       => "1934356085",
                    :isbn13     => "9781934356081",
                    :book_id    => "programming_ruby_1_9",
                    :publisher  => "Pragmatic Bookshelf",
                    :title      => 'Programming Ruby 1.9',
                    :long_title => "Programming Ruby 1.9: The Pragmatic Programmers' Guide",
                    :authors    => "Dave Thomas, Chad Fowler, Andy Hunt" }
    end

    context 'when querying for a book by isbn' do
      it 'indexes by isbn.' do
        result = BookWorm.find(:isbn, @book_data[:isbn])
        @book_data.each do |key,val|
          result.send(key).should == val
        end
      end

      it 'indexes by isbn13.' do
        result = BookWorm.find(:isbn, @book_data[:isbn13])
        @book_data.each do |key,val|
          result.send(key).should == val
        end
      end

      context 'when using #find_book hepers' do
        it 'indexes by isbn more easily.' do
          result = BookWorm.find_by_isbn(@book_data[:isbn])
          @book_data.each do |key,val|
            result.send(key).should == val
          end
        end

        it 'indexes by isbn13 more conveniently.' do
          result = BookWorm.find_by_isbn(@book_data[:isbn13])
          @book_data.each do |key,val|
            result.send(key).should == val
          end
        end
      end

      context 'when querying for a book by title' do
        it 'indexes books by title' do
          result = BookWorm.find(:title, @book_data[:title])
          @book_data.each do |key,val|
            result.send(key).should == val
          end
        end

        context 'when using #find_book helpers' do
          it 'indexes by title more conveniently.' do
            result = BookWorm.find_by_title(@book_data[:title])
            @book_data.each do |key,val|
              result.send(key).should == val
            end
          end
        end
      end

      context 'when querying for a book by combined index' do
        before :each do
          @combined_index = "#{@book_data[:title]} #{@book_data[:publisher]} #{@book_data[:authors]}"
        end

        it 'indexes using several combined fields' do
          @combined_index = "#{@book_data[:title]} #{@book_data[:publisher]} #{@book_data[:authors]}"
          result = BookWorm.find(:combined, @combined_index)
          @book_data.each do |key,val|
            result.send(key).should == val
          end
        end

        context 'when querying for a book by combined index' do
          it 'uses combined index more conveniently.' do
            result = BookWorm.find_by_combined_index(@combined_index)
            @book_data.each do |key,val|
              result.send(key).should == val
            end
          end
        end
      end

      context 'when querying for a book by full index' do
        before :each do
          @summary = "making Ruby a favorite tool of intelligent, forward-thinking programmers"
        end

        it 'indexes using several full fields' do
          result = BookWorm.find(:full, @summary)
          @book_data.each do |key,val|
            result.send(key).should == val
          end
        end

        context 'when querying for a book by full index' do
          it 'uses full index more conveniently.' do
            result = BookWorm.find_by_full_index(@summary)
            @book_data.each do |key,val|
              result.send(key).should == val
            end
          end
        end
      end
    end
  end # end find

  describe '#find_all' do
    context 'when querying for a collection of books' do
      it 'returns an empty array when no results are found' do
        BookWorm.find_all(:isbn, 'Jiveturkey').should be_empty
      end
    end

    context 'when finding without a specified index' do
      it 'defaults to full index' do
        BookWorm.should_receive(:query_isbndb).with(:full, "foobarbaz")
        BookWorm.find_all('foobarbaz')
      end
    end

    context 'when finding with a non-supported index' do
      it 'defaults to a full index' do
        BookWorm.should_receive(:query_isbndb).with(:full, '1934356085')
        BookWorm.find_all(:jiveturkey, '1934356085')
      end
    end

    context 'when querying for a collection of books by isbn' do
      it 'indexes by isbn' do
        BookWorm.find_all(:isbn, '1934356085').each do |book|
          book.isbn.should == '1934356085'
        end
      end

      it 'indexes by isbn13' do
        BookWorm.find_all(:isbn, '9781934356081').each do |book|
          book.isbn13.should == '9781934356081'
        end
      end

      context 'when using #find_all convenience helpers' do
        it 'conveniently indexes by isbn' do
          BookWorm.find_all_by_isbn('1934356085').each do |book|
            book.isbn.should == '1934356085'
          end
        end

        it 'conveniently indexes by isbn13' do
          BookWorm.find_all_by_isbn('9781934356081').each do |book|
            book.isbn13.should == '9781934356081'
          end
        end
      end
    end

    context 'when querying for a collection of books by title' do
      it 'has results that contain the title argument' do
        BookWorm.find_all(:title, 'Ruby Rails').each do |book|
          book.title.should =~ /ruby|rails/i
        end
      end

      context 'when using #find_books helpers' do
        it 'has results that contain the title argument' do
          BookWorm.find_all_by_title('Ruby Rails').each do |book|
            book.title.should =~ /ruby|rails/i
          end
        end
      end
    end

    context 'when querying for a collection of books by a combined index' do
      it 'has results that contain the arguments' do
        BookWorm.find_all(:combined, 'Ruby Rails').each do |book|
          book.title.should =~ /ruby|rails/i
        end
      end

      context 'when using #find_books helpers' do
        it 'has results that contain the arguments' do
          BookWorm.find_all_by_combined_index('Ruby Hansson Pragmatic Rails').each do |book|
            title     = book.title     =~ /ruby|rails/i
            author    = book.authors   =~ /hansson/i
            publisher = book.publisher =~ /pragmatic/i
            (title || author || publisher).should be_true
          end
        end
      end
    end

    context 'when querying for a collection of books by a full index' do
      it 'has results that match the full index' do
        books = BookWorm.find_all(:full, 'Ruby Rails Pragmatic Programming')
        books.collect{ |book| book.title }.join('_').should =~ /ruby|rails/i
      end

      context 'when using #find_books helpers' do
        it 'has results that contain the arguments for full index search' do
          books = BookWorm.find_all_by_full_index('Ruby Rails Pragmatic Programming')
          books.collect{ |book| book.title }.join('_').should =~ /ruby|rails/i
        end
      end
    end
  end #end find_all

  context 'by default include current average price of found books' do
    context 'when using a find method' do
      it 'includes prices' do
        book = BookWorm.find(:isbn, '9781934356050')
        book.average_price.to_s.should =~ /\d+\.\d{2}/
      end
    end

    context 'when using a find_all method' do
      it 'includes prices' do
        BookWorm.find_all(:combined, 'Ruby Rails').each do |book|
          book.average_price.to_s.should =~ /\d+\.\d{2}/
        end
      end
    end
  end
end
