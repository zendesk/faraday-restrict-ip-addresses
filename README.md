![repo-checks](https://github.com/zendesk/faraday-restrict-ip-addresses/workflows/repo-checks/badge.svg)
Faraday::RestrictIPAddresses
============================

Prevent Faraday from hitting an arbitrary list of IP addresses, with helpers
for RFC 1918 networks, RFC 6890 networks, and localhost.

System DNS facilities are used, so lookups should be cached instead of making
another request. Addresses are invalid if a host has has at least one invalid
DNS entry.

Usage
=====

```ruby
faraday = Faraday.new do |builder|
  builder.request :url_encoded
  builder.request :restrict_ip_addresses, allow_url: lambda {|url| false }
  builder.adapter Faraday.default_adapter
end

#### Author

Dat @bhuga with shoutouts to @mastahyeti's [gist.](https://gist.github.com/mastahyeti/8497793)

#### UNLICENSE

It's right there.
