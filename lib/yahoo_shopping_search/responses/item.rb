# frozen_string_literal: true

module YahooShoppingSearch
  module Responses
    class Item < Base

      # start + results sum's mixium is 1000
      MAX_RESULTS_COUNT = 1000
      DEFAULT_RESULTS_COUNT = 20

      # @param body [String]
      # @param params [Hash]
      def initialize(body, params = {})
        @body = JSON.parse(body)
        @params = params
      end

      # @return [Boolean]
      def has_next_page?
        if total_results_count >= MAX_RESULTS_COUNT
          MAX_RESULTS_COUNT >= start_position + results_count
        else
          total_results_count - start_position - results_count > 0
        end
      end

      # @return [Array<YahooShoppingSearch::Resources::Item>]
      def next_page!
        raise NextPageNotFound.new('Next page not found') unless has_next_page?
        @body = client_class.search(next_search_condition).body
        @params = next_search_condition

        items
      end

      # @return [Integer]
      def start_position
        @body['firstResultsPosition']
      end

      # @return [Integer]
      def results_count
        @body['totalResultsReturned']
      end

      # @return [Integer]
      def total_results_count
        @body['totalResultsAvailable']
      end

      # @return [Hash]
      def search_condition
        params
      end

      # @return [Hash]
      def next_search_condition
        condition = search_condition
        condition['start'] = start_position + (condition['results'] || DEFAULT_RESULTS_COUNT)

        condition
      end

      # @return [Array<Hash>]
      def sources
        body['hits']
      end

      # @return [ClassName]
      def resource_class
        ::YahooShoppingSearch::Resources::Item
      end

      # @return [ClassName]
      def client_class
        ::YahooShoppingSearch::Clients::Item
      end
    end
  end
end
