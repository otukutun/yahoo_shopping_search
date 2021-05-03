# frozen_string_literal: true

module YahooShoppingSearch
  module Responses
    class Base
      include ::Enumerable

      # @param body [String]
      # @param params [Hash]
      def initialize(body, params = {})
        @body = JSON.parse(body)
        @params = params
      end

      # @return [Hash]
      def body
        @body
      end

      # @return [Hash]
      def params
        @params
      end

      # @note Implementation for Enumerable
      def each(&block)
        items.each(&block)
      end

      # @return [Array<YahooShoppingSearch::Resources::Base>]
      def items
        (sources || []).map do |source|
          resource_class.new(source)
        end
      end

      # Specify class name
      def sources
        raise NotImplementedError
      end

      # Specify class name
      def resource_class
        raise NotImplementedError
      end

      # @param index [Integer]
      # @return [YahooShoppingSearch::Resources::Base | nil]
      def [](index)
        items[index]
      end

      # @return [YahooShoppingSearch::Resources::Base | nil]
      def last
        items.last
      end
    end
  end
end
