# frozen_string_literal: true

require 'spec_helper'

RSpec.describe YahooShoppingSearch::Responses::Item do
  let(:response) { YahooShoppingSearch::Responses::Item }

  describe '#start_position' do
    let(:body) { { 'firstResultsPosition' => 1 }.to_json }
    it { expect(response.new(body).start_position).to eq(1) }
  end

  describe '#results_count' do
    let(:body) { { 'totalResultsReturned' => 10 }.to_json }
    it { expect(response.new(body).results_count).to eq(10) }
  end

  describe '#total_results_count' do
    let(:body) { { 'totalResultsAvailable' => 100 }.to_json }
    it { expect(response.new(body).total_results_count).to eq(100) }
  end

  describe '#search_condition' do
    let(:body) { { 'request' => { 'query' => 'ビール' } }.to_json }
    let(:params) { {'query' => 'ビール', 'seller_id' => 'seller_test' } }
    it { expect(response.new(body, params).search_condition).to eq(params) }
  end

  describe '#next_search_condition' do
    context 'with results query' do
      let(:body) do
        { 'firstResultsPosition' => 1, 'request' => { 'query' => 'ビール' } }.to_json
      end
      let(:params) { {'query' => 'ビール', 'seller_id' => 'seller_test', 'results' => 100 } }

      it { expect(response.new(body, params).next_search_condition).to eq({ 'query' => 'ビール', 'results' => 100, 'seller_id' => 'seller_test', 'start' => 101 }) }
    end

    context 'with only keyword query' do
      let(:body) do
        { 'firstResultsPosition' => 1, 'request' => { 'query' => 'ビール' } }.to_json
      end
      let(:params) { {'query' => 'ビール', 'start' => 21 } }

      it { expect(response.new(body, params).next_search_condition).to eq({ 'query' => 'ビール', 'start' => 21 }) }
    end
  end

  describe '#each' do
    let(:body) do
      { 'firstResultsPosition' => 1, 'hits' => [
        { 'index' => 1, 'name' => 'ビール1' },
        { 'index' => 2, 'name' => 'ビール2' },
      ]}.to_json
    end

      it { expect(response.new(body).respond_to?(:each)).to be_truthy }
      it { expect(response.new(body).first.is_a?(YahooShoppingSearch::Resources::Item)).to be_truthy }
      it { expect(response.new(body).first['index']).to eq(1) }
      it { expect(response.new(body).first['name']).to eq('ビール1') }
  end

  describe '#has_next_page?' do
    context 'when total_results_count is equal or greater than 1000 and start_position is greater than 981' do
      let(:body) { { 'totalResultsAvailable' => 1000, 'firstResultsPosition' => 982, 'totalResultsReturned' => 20 }.to_json }
      it { expect(response.new(body).has_next_page?).to be_falsey }
    end

    context 'when total_results_count is equal or greater than 1000 and start_position is 980' do
      let(:body) { { 'totalResultsAvailable' => 1000, 'firstResultsPosition' => 980, 'totalResultsReturned' => 20 }.to_json }
      it { expect(response.new(body).has_next_page?).to be_truthy }
    end

    context 'when total_results_count is less than 1000 and has next page' do
      let(:body) { { 'totalResultsAvailable' => 200, 'firstResultsPosition' => 1, 'totalResultsReturned' => 20 }.to_json }
      it { expect(response.new(body).has_next_page?).to be_truthy }
    end

    context 'when total_results_count is less than 1000 and doesnt have next page' do
      let(:body) { { 'totalResultsAvailable' => 200, 'firstResultsPosition' => 180, 'totalResultsReturned' => 20 }.to_json }
      it { expect(response.new(body).has_next_page?).to be_falsey }
    end
  end

  describe '#next_page!' do
    context 'doesnt have next page' do
      let(:body) { { 'totalResultsAvailable' => 200, 'firstResultsPosition' => 180, 'totalResultsReturned' => 20 }.to_json }
      it { expect { response.new(body).next_page!}.to raise_error(YahooShoppingSearch::NextPageNotFound) }
    end

    context 'have next page' do
      let(:body) { { 'totalResultsAvailable' => 200, 'firstResultsPosition' => 1, 'totalResultsReturned' => 20, 'request' => { 'query' => 'ビール' }}.to_json }
      let(:params) { { 'query' => 'ビール', 'start' => 21} }
      let(:res) { response.new(body, params) }
      let(:next_body) { { 'totalResultsAvailable' => 200, 'firstResultsPosition' => 21, 'totalResultsReturned' => 20, 'request' => { 'start' => 21 }}.to_json }
      let(:query) do
        base_params = { appid: YahooShoppingSearch.config.app_id }
        base_params[:affiliate_id] = YahooShoppingSearch.config.affiliate_id if YahooShoppingSearch.config.affiliate_id&.present?
        base_params[:affiliate_type] = YahooShoppingSearch.config.affiliate_type if YahooShoppingSearch.config.affiliate_type&.present?
        base_params.merge!(params)

        base_params.to_query
      end


      before do
        stub_request(:get, "https://shopping.yahooapis.jp/ShoppingWebService/V3/itemSearch?#{query}").
          to_return(body: next_body, status: 200, headers: {'content-type': 'application/json'})
        res.next_page!
      end

      it { expect(res.start_position).to eq(21) }
      it { expect(res.results_count).to eq(20)  }
      it { expect(res.total_results_count).to eq(200) }
    end
  end
end
