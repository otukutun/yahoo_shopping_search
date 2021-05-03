# frozen_string_literal: true

module YahooShoppingSearch
  module Clients
    class Item < Base
      class << self
        def response_class_name
          Responses::Item
        end

        def url
          'https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch'
        end
      end
    end
  end
end
