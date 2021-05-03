# frozen_string_literal: true

RSpec.describe YahooShoppingSearch::Config do
  describe '#affiliate_id' do
    context 'when pid and sid are not set' do
      before do
        YahooShoppingSearch.configure do |config|
          config.app_id = 'somevalue'
          config.affiliate_type = 'somevalue'
          config.sid = nil
          config.pid = nil
        end
      end

      it do
        expect(YahooShoppingSearch.config.affiliate_id).to be_nil
      end
    end

    context 'when pid and sid are set' do
      before do
        YahooShoppingSearch.configure do |config|
          config.app_id = 'somevalue'
          config.affiliate_type = 'somevalue'
          config.sid = 'test'
          config.pid = 'test2'
        end
      end

      it { expect(YahooShoppingSearch.config.affiliate_id).to eq(URI.encode("https://ck.jp.ap.valuecommerce.com/servlet/referral?sid=test&pid=test2&vc_url=")) }
    end
  end
end
