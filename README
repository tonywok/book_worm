## Usage
  gem install book_worm

## Indices

### Isbn
Search on ISBN, value is set the ISBN you are interested in.

#### Example
  BookWorm.find(:isbn, "1234567890")

### Title
Keywords search on book title, long title, and latin-ized title for unicode titles.

#### Example
  BookWorm.find(:title, "Programming Ruby")

### Combined
Search index that combines titles, authors, and publisher name.

### Full
Search index that includes titles, authors, publisher name, summary, notes, awards information, etc -- practically every bit of textual information ISBNdb.com has about books.

## Configuration

BookWorm::Configuration.configure do |settings|
  settings[:api_key] = "YOUR_ISBNDB_API_KEY"
end

