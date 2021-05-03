# frozen_string_literal: true

require 'active_support/all'

RSpec.describe YahooShoppingSearch::Clients::Item do
  let(:client) { YahooShoppingSearch::Clients::Item }

  describe '#search' do
    let(:query) do
      params = { appid: YahooShoppingSearch.config.app_id }
      params[:affiliate_id] = YahooShoppingSearch.config.affiliate_id if YahooShoppingSearch.config.affiliate_id&.present?
      params[:affiliate_type] = YahooShoppingSearch.config.affiliate_type if YahooShoppingSearch.config.affiliate_type&.present?

      params.to_query
    end

    context 'when it returns response class' do
      before do
        stub_request(:get, "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?#{query}").
          to_return(body: {}.to_json, status: 200, headers: {'content-type': 'application/json'})
      end

      it do
        expect(client.search().class).to eq(YahooShoppingSearch::Responses::Item)
      end
    end

    context 'when it raise bad request exception' do
      before do
        stub_request(:get, "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?#{query}").
          to_return(body: { 'Error': { 'Message': 'Bad request error'}}.to_json, status: 400, headers: {'content-type': 'application/json'}).
          to_raise(YahooShoppingSearch::BadRequestError)
      end

      it do
        expect { client.search()}.to raise_error(YahooShoppingSearch::BadRequestError)
      end
    end

    context 'when it raise bad request exception with xml response' do
      before do
        stub_request(:get, "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?#{query}").
          to_return(body: '<?xml version="1.0" encoding="UTF-8"?><Error><Message>Bad Request</Message></Error>', status: 400, headers: {'content-type': 'text/xml'}).
          to_raise(YahooShoppingSearch::BadRequestError)
      end

      it do
        expect { client.search()}.to raise_error(YahooShoppingSearch::BadRequestError)
      end
    end

    context 'when it raise unauthorized exception' do
      before do
        stub_request(:get, "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?#{query}").
          to_return(body: { 'Error': { 'Message': 'Unauthorized error'}}.to_json, status: 401, headers: {'content-type': 'application/json'}).
          to_raise(YahooShoppingSearch::UnauthorizedError)
      end

      it do
        expect { client.search()}.to raise_error(YahooShoppingSearch::UnauthorizedError)
      end
    end

    context 'when it raise forbidden exception' do
      before do
        stub_request(:get, "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?#{query}").
          to_return(body: { 'Error': { 'Message': 'Forbidden error'}}.to_json, status: 403, headers: {'content-type': 'application/json'}).
          to_raise(YahooShoppingSearch::ForbiddenError)
      end

      it do
        expect { client.search()}.to raise_error(YahooShoppingSearch::ForbiddenError)
      end
    end

    context 'when it raise not found exception' do
      before do
        stub_request(:get, "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?#{query}").
          to_return(body: { 'Error': { 'Message': 'Not found error'}}.to_json, status: 404, headers: {'content-type': 'application/json'}).
          to_raise(YahooShoppingSearch::NotFoundError)
      end

      it do
        expect { client.search()}.to raise_error(YahooShoppingSearch::NotFoundError)
      end
    end

    context 'when it raise internal server exception' do
      before do
        stub_request(:get, "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?#{query}").
          to_return(body: { 'Error': { 'Message': 'Not found error'}}.to_json, status: 500, headers: {'content-type': 'application/json'}).
          to_raise(YahooShoppingSearch::InternalServerError)
      end

      it do
        expect { client.search()}.to raise_error(YahooShoppingSearch::InternalServerError)
      end
    end

    context 'when it raise service unavailable exception' do
      before do
        stub_request(:get, "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?#{query}").
          to_return(body: { 'Error': { 'Message': 'Not found error'}}.to_json, status: 503, headers: {'content-type': 'application/json'}).
          to_raise(YahooShoppingSearch::ServiceUnavailableError)
      end

      it do
        expect { client.search()}.to raise_error(YahooShoppingSearch::ServiceUnavailableError)
      end
    end
  end
end
