require 'faraday/restrict_ip_addresses'
require 'spec_helper'

describe Faraday::RestrictIPAddresses do

  def middleware(verifier, opts = {})
    @app = described_class.new(lambda{|env| env}, verifier, opts)
  end

  def denied(*addresses)
    expect(-> { allowed(*addresses) }).to raise_error(Faraday::RestrictIPAddresses::AddressNotAllowed)
  end

  it "denies access when the verifier returns false" do
    middleware(lambda { |env| false })

    expect { @app.call({url: 'http://example.com'}) }.to raise_error(Faraday::RestrictIPAddresses::AddressNotAllowed)
  end

  it "allows access when the verifier returns true" do
    middleware(lambda { |env| true })

    @app.call({url: 'http://example.com'})
  end

  it "passes the URL to the verifier" do
    url = 'http://example.com'

    verifier = lambda do |u|
      u.should equal(url)
    end

    middleware(verifier)

    @app.call({url: url})
  end
end
