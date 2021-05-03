# frozen_string_literal: true

require 'yahoo_shopping_search/version'
require 'yahoo_shopping_search/config'

module YahooShoppingSearch
  class BadRequestError < StandardError; end
  class UnauthorizedError < StandardError; end
  class ForbiddenError < StandardError; end
  class NotFoundError < StandardError; end
  class InternalServerError < StandardError; end
  class ServiceUnavailableError < StandardError; end

  class NextPageNotFound < StandardError; end

  class << self
    def configure
      yield config
    end

    def config
      @_config ||= ::YahooShoppingSearch::Config.new
    end
  end
end
