module BookWorm
  module Searchable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      INDICES = [:isbn, :title, :combined, :full]

      INDICES.each do |index|
        index_name = (index.to_s =~ /full|combined/ ? "#{index}_index" : index)

        define_method "find_by_#{index_name}" do |arg|
          find(index, arg)
        end

        define_method "find_all_by_#{index_name}" do |arg|
          find_all(index, arg)
        end
      end

      def find(index, value)
        normalize(query_isbndb(index, value))[0]
      end

      def find_all(index, value)
        normalize(query_isbndb(index, value))
      end

      def query_base
        "/api/#{self.to_s.gsub(/^\w+::/, '').downcase << 's'}.xml"
      end

      def query_isbndb(index, value)
        get(query_base, :query => { :index1 => index,
                                    :value1 => value,
                                    :access_key => Configuration::API_KEY })
      end

      def normalize(results)
        begin
          [results['ISBNdb']['BookList']['BookData']].flatten.collect do |book|
            Book.new(book)
          end
        rescue
          []
        end
      end

    end
  end
end


