require 'faraday/restrict_ip_addresses/version'
require 'ipaddr'

module Faraday
  class RestrictIPAddresses < Faraday::Middleware
    class AddressNotAllowed < Faraday::Error::ClientError ; end

    def initialize(app, verifier, options = {})
      super(app)
      @verifier = verifier
    end

    def call(env)
      if allowed?(env)
        @app.call(env)
      else
        raise AddressNotAllowed.new "Address not allowed for #{env[:url]}"
      end
    end

    def allowed?(env)
      url = env[:url]
      !!@verifier.call(url)
    end

  end
  Request.register_middleware restrict_ip_addresses: lambda { RestrictIPAddresses }
end
