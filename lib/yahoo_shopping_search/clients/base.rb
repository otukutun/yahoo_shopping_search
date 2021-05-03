# frozen_string_literal: true

module YahooShoppingSearch
  module Clients
    class Base
      class << self
        def search(params = {})
          queries = params.merge(base_params).to_query

          uri = URI.parse("#{url}?#{queries}")
          req = Net::HTTP::Get.new uri

          Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
            res = http.request(req)
            case res
            when Net::HTTPOK
              return response_class_name.new(res.body, params)
            when Net::HTTPBadRequest
              raise BadRequestError.new(error_message(res))
            when Net::HTTPUnauthorized
              raise UnauthorizedError.new(error_message(res))
            when Net::HTTPForbidden
              raise ForbiddenError.new(error_message(res))
            when Net::HTTPNotFound
              raise NotFoundError.new(error_message(res))
            when Net::HTTPInternalServerError
              raise InternalServerError.new(error_message(res))
            when Net::HTTPServiceUnavailable
              raise ServiceUnavailableError.new(error_message(res))
            end
          end
        end

        def response_class_name
          raise NotImplementedError
        end

        def url
          raise NotImplementedError
        end

        private

        def error_message(res)
          if xml_response?(res)
            doc = REXML::Document.new(res.body)
            hash = Hash.from_xml(doc.to_s)
            return hash['Error']['Message']
          end

          json = JSON.parse(res.body)
          json['Error']['Message']
        end

        def xml_response?(res)
          res.header['content-type'].include?('text/xml')
        end

        def to_query(params)
          params.map { |k, v| "#{URI.encode(k)}=#{URI.encode(v)}" }.join('&')
        end

        def base_params
          params = { appid: YahooShoppingSearch.config.app_id }
          params[:affiliate_id] = YahooShoppingSearch.config.affiliate_id if YahooShoppingSearch.config.affiliate_id&.present?
          params[:affiliate_type] = YahooShoppingSearch.config.affiliate_type if YahooShoppingSearch.config.affiliate_type&.present?

          params
        end
      end
    end
  end
end
