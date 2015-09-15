require 'cgi'
require 'faraday'
require 'faraday_middleware'
require 'json'

require File.dirname(__FILE__) + '/relateiq/riq_object'
require File.dirname(__FILE__) + '/relateiq/riq_list'
require File.dirname(__FILE__) + '/relateiq/api_resource'

require File.dirname(__FILE__) + '/relateiq/list'
require File.dirname(__FILE__) + '/relateiq/contact'

module RelateIQ
  class Client

    attr_accessor :api_key, :api_secret, :base_url, :version

    def initialize(params)
      raise ArgumentError, "You must include both the api_key and api_secret" unless (params.include?(:api_key) && params.include?(:api_secret))
      @api_key = params[:api_key]
      @api_secret = params[:api_secret]
      @base_url = params[:base_url]
    end

    def get(string, params = {})
      string += "#{URI.parse(string).query ? '&' : '?'}#{uri_encode(params)}" if params && params.any?
      request :get, uri(string)
    end

    def post(string, params={})
      request :post, uri(string), params
    end

    def put(string, params={})
      request :put, uri(string), params
    end

    def delete(string)
      request :delete, uri(string)
    end

    private
    def uri_encode(params = {})
      params.map { |k,v| "#{k}=#{url_encode(v)}" }.join('&')
    end

    def url_encode(key)
      URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    def uri(string)
      string
    end

    def request(method,*args)
      conn = Faraday.new(:url => @base_url) do |faraday|
        # faraday.response :logger
        faraday.request :json
        faraday.response :json, :content_type => /\bjson$/
        faraday.use :instrumentation
        faraday.adapter Faraday.default_adapter
      end
      conn.basic_auth(@api_key, @api_secret)
      conn.headers.update({'Content-Type' => 'application/json'})

      res = conn.send method.to_sym, *args

      case res.status
        when 401
          raise "Invalid credentials"
        when 400...599
          if res.body.include? 'error'
            raise [res.body['error'], *args].join(' ')
          else
            #raise 'Unknown error'
            raise [res.body, *args].join(' ')
          end
        else
          res.body
      end
    end

  end
end
