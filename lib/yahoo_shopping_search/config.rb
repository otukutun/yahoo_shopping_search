# frozen_string_literal: true

module YahooShoppingSearch
  class Config
    attr_accessor :app_id, :affiliate_type, :sid, :pid

    # REF: https://developer.yahoo.co.jp/appendix/shopping/affiliate.html
    # @return [String]
    def affiliate_id
      return if sid.nil? || pid.nil?

      base_url = 'https://ck.jp.ap.valuecommerce.com/servlet/referral'
      URI.encode("#{base_url}?sid=#{sid}&pid=#{pid}&vc_url=")
    end
  end
end
