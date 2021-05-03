# frozen_string_literal: true

module YahooShoppingSearch
  module Resources
    class Item
      # @param hash [Hash]
      def initialize(hash)
        @item = hash
      end

      # @param key [String]
      # @return [Hash, nil]
      def [](key)
        @item[key]
      end
    end
  end
end
