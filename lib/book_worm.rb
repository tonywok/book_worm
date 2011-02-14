# == BookWorm
#
# A module that interacts with the ISBN Database at isbndb.com
module BookWorm
  require 'book_worm/configuration'
  require 'book_worm/searchable'
  extend Searchable
end
