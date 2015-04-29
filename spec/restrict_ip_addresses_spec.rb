require 'faraday/restrict_ip_addresses'
require 'spec_helper'

describe Faraday::RestrictIPAddresses do

  def middleware(opts = {})
    @app = described_class.new(lambda{|env| env}, opts)
  end

  it "denies access when the verifier returns false" do
    middleware(:allow_url => lambda { |env| false })

    expect { @app.call({url: 'http://example.com'}) }.to raise_error(Faraday::RestrictIPAddresses::AddressNotAllowed)
  end

  it "allows access when the verifier returns true" do
    middleware(:allow_url => lambda { |env| true })

    @app.call({url: 'http://example.com'})
  end

  it "passes the URL to the verifier" do
    url = 'http://example.com'

    verifier = lambda do |u|
      u.should equal(url)
    end

    middleware(:allow_url => verifier)

    @app.call({url: url})
  end
end
